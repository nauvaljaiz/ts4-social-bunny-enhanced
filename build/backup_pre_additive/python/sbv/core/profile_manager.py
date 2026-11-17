# -*- coding: utf-8 -*-
"""Profile management, bio editing, completeness scoring, and privacy filtering."""

from typing import Any, Dict

from .models import AccountCategory, AccountPrivacy

MAX_BIO_LENGTH = 160


class ProfileManager(object):
    """Handles Sim profile metadata, bio edits, visits, and profile quality."""

    def __init__(self, account_manager: Any) -> None:
        self._accounts = account_manager

    def update_bio(self, sim_id: Any, bio_text: str) -> Dict[str, Any]:
        acc = self._accounts.get_account(sim_id)
        if acc is None:
            return {"ok": False, "error": "Account not found."}
        cleaned = (bio_text or "").replace("\r", " ").replace("\n", " ").strip()
        if len(cleaned) > MAX_BIO_LENGTH:
            cleaned = cleaned[:MAX_BIO_LENGTH]
        acc["bio"] = cleaned
        return {"ok": True, "bio": cleaned}

    def record_profile_visit(self, target_sim_id: Any, viewer_sim_id: Any) -> None:
        if str(target_sim_id) == str(viewer_sim_id):
            return
        acc = self._accounts.get_account(target_sim_id)
        if acc is not None:
            acc["profile_visits"] = int(acc.get("profile_visits", 0)) + 1

    def compute_profile_completeness(self, sim_id: Any, post_count: int) -> float:
        """Compute 0..100 profile completeness score for verification eligibility."""
        acc = self._accounts.get_account(sim_id)
        if acc is None:
            return 0.0
        score = 20.0  # Has valid Sim identity & avatar
        if acc.get("username") and not acc["username"].startswith("sim_"):
            score += 20.0
        if len((acc.get("bio") or "").strip()) >= 10:
            score += 25.0
        if acc.get("category") and acc["category"] != AccountCategory.PERSONAL:
            score += 15.0
        if post_count >= 1:
            score += 10.0
        if post_count >= 3:
            score += 10.0
        return min(100.0, score)

    def can_view_private_content(
        self,
        target_sim_id: Any,
        viewer_sim_id: Any,
        follower_manager: Any,
    ) -> bool:
        """Enforce account privacy and block rules."""
        t_key = str(target_sim_id)
        v_key = str(viewer_sim_id)
        if t_key == v_key:
            return True
        if follower_manager.is_blocked(t_key, v_key) or follower_manager.is_blocked(v_key, t_key):
            return False
        acc = self._accounts.get_account(t_key)
        if acc is None:
            return False
        if acc.get("privacy", AccountPrivacy.PUBLIC) == AccountPrivacy.PUBLIC:
            return True
        return follower_manager.is_following(v_key, t_key)
