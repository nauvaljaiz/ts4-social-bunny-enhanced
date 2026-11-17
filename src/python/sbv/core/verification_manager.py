# -*- coding: utf-8 -*-
"""Verification eligibility scoring, application workflow, appeals, and badge lifecycle."""

from typing import Any, Dict, List, Optional

from .models import (
    AccountCategory,
    AccountStatus,
    ApplicationStatus,
    DEFAULT_VERIFICATION_CONFIG,
    VerificationTier,
)


class VerificationManager(object):
    """Manages authentic, persistent Social Bunny verification status & review workflow."""

    def __init__(self, config: Optional[Dict[str, Any]] = None) -> None:
        self.config: Dict[str, Any] = {
            "weights": dict(DEFAULT_VERIFICATION_CONFIG["weights"]),
            "thresholds": dict(DEFAULT_VERIFICATION_CONFIG["thresholds"]),
            "reapplication_cooldown_hours": DEFAULT_VERIFICATION_CONFIG["reapplication_cooldown_hours"],
            "review_delay_hours": DEFAULT_VERIFICATION_CONFIG["review_delay_hours"],
            "min_reputation_for_verification": DEFAULT_VERIFICATION_CONFIG["min_reputation_for_verification"],
            "min_posts_for_verification": DEFAULT_VERIFICATION_CONFIG["min_posts_for_verification"],
        }
        if config:
            self.config.update(config)
        self._applications: Dict[str, Dict[str, Any]] = {}
        self._history: Dict[str, List[Dict[str, Any]]] = {}
        self._next_app_seq: int = 1

    def load_dict(self, data: Dict[str, Any]) -> None:
        self._applications = {}
        self._history = {}
        if not isinstance(data, dict):
            return
        self._next_app_seq = int(data.get("next_app_seq", 1))
        apps = data.get("applications", {})
        if isinstance(apps, dict):
            for sid, app in apps.items():
                if isinstance(app, dict):
                    self._applications[str(sid)] = dict(app)
        hist = data.get("history", {})
        if isinstance(hist, dict):
            for sid, items in hist.items():
                if isinstance(items, list):
                    self._history[str(sid)] = [dict(x) for x in items if isinstance(x, dict)][-20:]

    def to_dict(self) -> Dict[str, Any]:
        return {
            "next_app_seq": self._next_app_seq,
            "applications": {k: dict(v) for k, v in self._applications.items()},
            "history": {k: list(v) for k, v in self._history.items() if v},
        }

    def get_latest_application(self, sim_id: Any) -> Optional[Dict[str, Any]]:
        return self._applications.get(str(sim_id))

    def get_history(self, sim_id: Any) -> List[Dict[str, Any]]:
        return list(self._history.get(str(sim_id), ()))

    def get_pending_applications(self) -> List[Dict[str, Any]]:
        return [
            app
            for app in self._applications.values()
            if app.get("decision") in (ApplicationStatus.PENDING, ApplicationStatus.UNDER_REVIEW)
        ]

    def evaluate_eligibility(
        self,
        account: Dict[str, Any],
        follower_count: int,
        posts: List[Dict[str, Any]],
        engagement_summary: Dict[str, Any],
        profile_completeness: float,
        now_ticks: int = 0,
    ) -> Dict[str, Any]:
        """Compute multi-factor Verification Score using configurable weights & category thresholds."""
        s_key = str(account["sim_id"])
        category = account.get("category", AccountCategory.PERSONAL)
        fame = int(account.get("fame_level", 0))
        rep = float(account.get("reputation", 50.0))
        post_count = len(posts)

        # 1. Authenticity (account standing, non-empty bio/handle, clean status)
        authenticity = 40.0
        if account.get("username") and not account["username"].startswith("sim_"):
            authenticity += 25.0
        if len((account.get("bio") or "").strip()) >= 8:
            authenticity += 20.0
        if account.get("status") == AccountStatus.ACTIVE and not account.get("badge_suspended"):
            authenticity += 15.0

        # 2. Notability (fame, followers, career/public figure status)
        notability = min(50.0, float(fame) * 14.0)
        notability += min(35.0, float(follower_count) * 1.4)
        if category in (AccountCategory.PUBLIC_FIGURE, AccountCategory.OFFICIAL_ORG):
            notability += 15.0
        elif account.get("career"):
            notability += 8.0
        notability = min(100.0, notability)

        # 3. Activity (post count & recency)
        activity = min(100.0, float(post_count) * 18.0)

        # 4. Engagement Quality
        eng_rate = float(engagement_summary.get("engagement_rate", 0.0))
        total_interactions = int(engagement_summary.get("likes", 0)) + int(engagement_summary.get("comments", 0))
        eng_quality = min(100.0, eng_rate * 2.2 + min(45.0, float(total_interactions) * 2.0))

        # 5. Reputation
        reputation_score = max(0.0, min(100.0, rep))

        # 6. Profile Quality
        profile_quality = max(0.0, min(100.0, profile_completeness))

        w = self.config["weights"]
        total_score = round(
            authenticity * w["authenticity"]
            + notability * w["notability"]
            + activity * w["activity"]
            + eng_quality * w["engagement_quality"]
            + reputation_score * w["reputation"]
            + profile_quality * w["profile_quality"],
            2,
        )

        threshold = float(self.config["thresholds"].get(category, 70.0))
        reasons: List[str] = []
        if account.get("status") == AccountStatus.SUSPENDED:
            reasons.append("Account is currently suspended.")
        if rep < float(self.config["min_reputation_for_verification"]):
            reasons.append("Reputation score must be at least {:.0f}.".format(self.config["min_reputation_for_verification"]))
        if post_count < int(self.config["min_posts_for_verification"]):
            reasons.append("Publish at least {} posts to establish activity.".format(self.config["min_posts_for_verification"]))
        if total_score < threshold:
            reasons.append("Verification score ({:.1f}) is below {} threshold ({:.1f}).".format(
                total_score, AccountCategory.LABELS.get(category, category), threshold
            ))

        cooldown_remaining_ticks = 0
        last_app = self._applications.get(s_key)
        if last_app and last_app.get("decision") == ApplicationStatus.REJECTED:
            cd_ticks = int(self.config["reapplication_cooldown_hours"]) * 60
            elapsed = max(0, int(now_ticks) - int(last_app.get("review_timestamp", 0)))
            if elapsed < cd_ticks:
                cooldown_remaining_ticks = cd_ticks - elapsed
                reasons.append("Reapplication cooldown active ({:.0f}h remaining).".format(cooldown_remaining_ticks / 60.0))

        is_verified = account.get("verification_tier", VerificationTier.NONE) in (
            VerificationTier.BLUE_VERIFIED,
            VerificationTier.OFFICIAL,
            VerificationTier.LEGACY,
        )
        if account.get("badge_suspended"):
            status = ApplicationStatus.SUSPENDED
        elif is_verified:
            status = ApplicationStatus.VERIFIED
        elif last_app and last_app.get("decision") in (ApplicationStatus.PENDING, ApplicationStatus.UNDER_REVIEW):
            status = last_app["decision"]
        elif last_app and last_app.get("decision") == ApplicationStatus.REVOKED:
            status = ApplicationStatus.REVOKED if reasons else ApplicationStatus.ELIGIBLE
        elif len(reasons) == 0:
            status = ApplicationStatus.ELIGIBLE
        elif last_app and last_app.get("decision") == ApplicationStatus.REJECTED and cooldown_remaining_ticks > 0:
            status = ApplicationStatus.REJECTED
        else:
            status = ApplicationStatus.NOT_ELIGIBLE

        return {
            "status": status,
            "score": total_score,
            "threshold": threshold,
            "eligible": len(reasons) == 0 and not is_verified,
            "reasons": reasons,
            "cooldown_hours": round(cooldown_remaining_ticks / 60.0, 1),
            "breakdown": {
                "authenticity": round(authenticity, 1),
                "notability": round(notability, 1),
                "activity": round(activity, 1),
                "engagement_quality": round(eng_quality, 1),
                "reputation": round(reputation_score, 1),
                "profile_quality": round(profile_quality, 1),
            },
        }

    def submit_application(
        self,
        account: Dict[str, Any],
        requested_tier: str,
        supporting_note: str,
        eligibility: Dict[str, Any],
        now_ticks: int = 0,
    ) -> Dict[str, Any]:
        s_key = str(account["sim_id"])
        if account.get("status") == AccountStatus.SUSPENDED:
            return {"ok": False, "error": "Suspended accounts cannot apply for verification."}
        if requested_tier not in (VerificationTier.BLUE_VERIFIED, VerificationTier.OFFICIAL, VerificationTier.LEGACY):
            requested_tier = VerificationTier.BLUE_VERIFIED

        existing = self._applications.get(s_key)
        if existing and existing.get("decision") in (ApplicationStatus.PENDING, ApplicationStatus.UNDER_REVIEW):
            return {"ok": False, "error": "An application is already under review."}
        if existing and existing.get("decision") == ApplicationStatus.REJECTED and eligibility.get("cooldown_hours", 0) > 0:
            return {"ok": False, "error": "Please wait for the reapplication cooldown to finish."}

        app_id = "app_{}".format(self._next_app_seq)
        self._next_app_seq += 1
        app = {
            "application_id": app_id,
            "sim_id": s_key,
            "requested_category": requested_tier,
            "supporting_note": (supporting_note or "").strip()[:200],
            "submission_timestamp": int(now_ticks),
            "review_timestamp": 0,
            "decision": ApplicationStatus.PENDING,
            "rejection_reason": "",
            "reviewer": "Pending Automated Review",
            "score_at_submission": float(eligibility.get("score", 0.0)),
            "threshold_at_submission": float(eligibility.get("threshold", 70.0)),
            "appealed": False,
        }
        self._applications[s_key] = app
        self._history.setdefault(s_key, []).append(dict(app))
        return {"ok": True, "application": app}

    def review_application(
        self,
        account: Dict[str, Any],
        eligibility: Dict[str, Any],
        now_ticks: int = 0,
        manual_decision: Optional[bool] = None,
        reviewer: str = "Social Bunny Verification Board",
        custom_reason: str = "",
    ) -> Dict[str, Any]:
        """Process a pending/under-review application automatically or manually."""
        s_key = str(account["sim_id"])
        app = self._applications.get(s_key)
        if app is None:
            return {"ok": False, "error": "No verification application found."}
        if app.get("decision") not in (ApplicationStatus.PENDING, ApplicationStatus.UNDER_REVIEW):
            return {"ok": False, "error": "Application is already finalized."}

        approved = manual_decision if manual_decision is not None else (
            float(eligibility.get("score", 0.0)) >= float(eligibility.get("threshold", 70.0))
            and float(account.get("reputation", 0.0)) >= float(self.config["min_reputation_for_verification"])
            and account.get("status") != AccountStatus.SUSPENDED
        )

        app["review_timestamp"] = int(now_ticks)
        app["reviewer"] = reviewer
        if approved:
            tier = app.get("requested_category", VerificationTier.BLUE_VERIFIED)
            if account.get("category") in (AccountCategory.BUSINESS, AccountCategory.OFFICIAL_ORG) and tier == VerificationTier.BLUE_VERIFIED:
                tier = VerificationTier.OFFICIAL
            account["verification_tier"] = tier
            account["verified_at"] = int(now_ticks)
            account["badge_suspended"] = False
            app["decision"] = ApplicationStatus.VERIFIED
            app["rejection_reason"] = ""
        else:
            reasons = eligibility.get("reasons") or []
            app["decision"] = ApplicationStatus.REJECTED
            app["rejection_reason"] = custom_reason or (reasons[0] if reasons else "Notability and engagement criteria not yet met.")

        self._history.setdefault(s_key, []).append(dict(app))
        return {"ok": True, "approved": approved, "application": app}

    def appeal_rejection(
        self,
        account: Dict[str, Any],
        appeal_note: str,
        eligibility: Dict[str, Any],
        now_ticks: int = 0,
    ) -> Dict[str, Any]:
        s_key = str(account["sim_id"])
        app = self._applications.get(s_key)
        if app is None or app.get("decision") != ApplicationStatus.REJECTED:
            return {"ok": False, "error": "No rejected application available to appeal."}
        if app.get("appealed"):
            return {"ok": False, "error": "An appeal has already been submitted for this application."}
        app["appealed"] = True
        app["supporting_note"] = (appeal_note or "").strip()[:200]
        app["decision"] = ApplicationStatus.UNDER_REVIEW
        app["reviewer"] = "Appeals Committee"
        # Immediate re-evaluation with slightly relaxed appeal check (+3 grace)
        grace_score = float(eligibility.get("score", 0.0)) + 3.0
        if grace_score >= float(eligibility.get("threshold", 70.0)) and account.get("status") == AccountStatus.ACTIVE:
            return self.review_application(account, eligibility, now_ticks=now_ticks, manual_decision=True, reviewer="Appeals Committee")
        self._history.setdefault(s_key, []).append(dict(app))
        return {"ok": True, "application": app}

    def suspend_badge(self, account: Dict[str, Any], now_ticks: int = 0, reason: str = "Community guideline violation") -> None:
        s_key = str(account["sim_id"])
        account["badge_suspended"] = True
        app = self._applications.get(s_key)
        if app:
            app["decision"] = ApplicationStatus.SUSPENDED
            app["rejection_reason"] = reason
            app["review_timestamp"] = int(now_ticks)
            self._history.setdefault(s_key, []).append(dict(app))

    def revoke_verification(self, account: Dict[str, Any], now_ticks: int = 0, reason: str = "Severe policy violation") -> None:
        s_key = str(account["sim_id"])
        account["verification_tier"] = VerificationTier.NONE
        account["badge_suspended"] = False
        app = self._applications.get(s_key)
        if app:
            app["decision"] = ApplicationStatus.REVOKED
            app["rejection_reason"] = reason
            app["review_timestamp"] = int(now_ticks)
            self._history.setdefault(s_key, []).append(dict(app))
