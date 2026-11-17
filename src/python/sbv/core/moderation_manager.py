# -*- coding: utf-8 -*-
"""Event-based community moderation, reports, warnings, suspensions, and revocations."""

from typing import Any, Dict, List, Optional

from .models import AccountStatus, ModerationAction, VerificationTier

VALID_REPORT_REASONS = (
    "harassment",
    "misinformation",
    "spam",
    "hate_speech",
    "impersonation",
)


class ModerationManager(object):
    """Handles content/account reports and rule-based progressive enforcement."""

    def __init__(self) -> None:
        self._reports: List[Dict[str, Any]] = []
        self._mod_log: Dict[str, List[Dict[str, Any]]] = {}
        self._next_report_seq: int = 1

    def load_dict(self, data: Dict[str, Any]) -> None:
        self._reports = []
        self._mod_log = {}
        if not isinstance(data, dict):
            return
        self._next_report_seq = int(data.get("next_report_seq", 1))
        for r in data.get("reports", []):
            if isinstance(r, dict):
                self._reports.append(dict(r))
        for sid, items in data.get("mod_log", {}).items():
            if isinstance(items, list):
                self._mod_log[str(sid)] = [dict(x) for x in items if isinstance(x, dict)][-30:]

    def to_dict(self) -> Dict[str, Any]:
        return {
            "next_report_seq": self._next_report_seq,
            "reports": self._reports[-120:],
            "mod_log": {k: list(v) for k, v in self._mod_log.items() if v},
        }

    def get_account_history(self, sim_id: Any) -> List[Dict[str, Any]]:
        return list(self._mod_log.get(str(sim_id), ()))

    def refresh_timed_penalties(self, account: Dict[str, Any], now_ticks: int) -> None:
        """Expire temporary restrictions/suspensions once their duration elapses."""
        status = account.get("status", AccountStatus.ACTIVE)
        if status == AccountStatus.RESTRICTED and int(account.get("restriction_until", 0)) <= now_ticks:
            account["status"] = AccountStatus.ACTIVE
            account["restriction_until"] = 0
        elif status == AccountStatus.SUSPENDED and int(account.get("suspension_until", 0)) <= now_ticks:
            account["status"] = AccountStatus.ACTIVE
            account["suspension_until"] = 0

    def file_report(
        self,
        reporter_sim_id: Any,
        target_sim_id: Any,
        reason: str,
        target_type: str = "post",
        target_id: str = "",
        now_ticks: int = 0,
        target_account: Optional[Dict[str, Any]] = None,
        post_manager: Any = None,
        verification_manager: Any = None,
        reputation_manager: Any = None,
    ) -> Dict[str, Any]:
        """Record a report and apply deterministic rule-based enforcement."""
        rep_key = str(reporter_sim_id)
        tgt_key = str(target_sim_id)
        if rep_key == tgt_key:
            return {"ok": False, "error": "You cannot report your own account."}

        # Prevent duplicate reports by same Sim for the same target item
        for r in self._reports:
            if (
                r.get("reporter_sim_id") == rep_key
                and r.get("target_sim_id") == tgt_key
                and r.get("target_id") == str(target_id)
            ):
                return {"ok": False, "error": "You have already reported this content."}

        clean_reason = reason if reason in VALID_REPORT_REASONS else "spam"
        report_id = "rep_{}".format(self._next_report_seq)
        self._next_report_seq += 1
        report = {
            "report_id": report_id,
            "reporter_sim_id": rep_key,
            "target_sim_id": tgt_key,
            "target_type": target_type,
            "target_id": str(target_id),
            "reason": clean_reason,
            "tick": int(now_ticks),
            "action_taken": ModerationAction.NONE,
        }
        self._reports.append(report)

        if target_account is None:
            return {"ok": True, "report": report, "action": ModerationAction.NONE}

        strikes = len(self._mod_log.get(tgt_key, ()))
        reports_for_item = sum(
            1 for r in self._reports if r["target_sim_id"] == tgt_key and r["target_id"] == str(target_id)
        )
        reports_for_account = sum(1 for r in self._reports if r["target_sim_id"] == tgt_key)

        action = ModerationAction.NONE
        details = ""

        # Rule-based escalation (never random)
        if clean_reason in ("harassment", "hate_speech") and reports_for_item >= 2:
            if target_type == "post" and post_manager and target_id:
                post_manager.delete_post(target_id, tgt_key, is_moderator=True)
            elif target_type == "comment" and post_manager and ":" in str(target_id):
                pid, cid = str(target_id).split(":", 1)
                post_manager.delete_comment(pid, cid, tgt_key, is_moderator=True)
            action = ModerationAction.CONTENT_REMOVAL
            details = "Content removed for violating community guidelines ({}).".format(clean_reason)
        elif reports_for_account >= 5 or strikes >= 4:
            if target_account.get("verification_tier", VerificationTier.NONE) != VerificationTier.NONE:
                if verification_manager:
                    verification_manager.revoke_verification(target_account, now_ticks, "Repeated community violations")
                action = ModerationAction.VERIFICATION_REVOKED
                details = "Verification revoked due to repeated severe violations."
            else:
                target_account["status"] = AccountStatus.SUSPENDED
                target_account["suspension_until"] = int(now_ticks) + 48 * 60
                action = ModerationAction.TEMP_SUSPENSION
                details = "Account temporarily suspended for 48 Sim hours."
        elif reports_for_account >= 3 or strikes >= 2:
            if target_account.get("verification_tier", VerificationTier.NONE) != VerificationTier.NONE and not target_account.get("badge_suspended"):
                if verification_manager:
                    verification_manager.suspend_badge(target_account, now_ticks, "Under moderation review")
                action = ModerationAction.BADGE_SUSPENDED
                details = "Verified badge suspended pending compliance."
            else:
                target_account["status"] = AccountStatus.RESTRICTED
                target_account["restriction_until"] = int(now_ticks) + 24 * 60
                action = ModerationAction.TEMP_RESTRICTION
                details = "Account posting restricted for 24 Sim hours."
        elif reports_for_account >= 2 or clean_reason in ("misinformation", "impersonation"):
            action = ModerationAction.WARNING
            details = "Official community warning issued ({}).".format(clean_reason)

        report["action_taken"] = action
        if action != ModerationAction.NONE:
            self._mod_log.setdefault(tgt_key, []).append({
                "action": action,
                "reason": clean_reason,
                "details": details,
                "tick": int(now_ticks),
                "report_id": report_id,
            })
            if reputation_manager:
                reputation_manager.adjust_reputation(target_account, -6.0, details, now_ticks)

        return {"ok": True, "report": report, "action": action, "details": details}
