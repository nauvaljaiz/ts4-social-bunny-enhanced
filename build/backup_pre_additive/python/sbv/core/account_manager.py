# -*- coding: utf-8 -*-
"""Persistent account identity, creation, categories, and username validation."""

import re
from typing import Any, Dict, List, Optional

from .models import (
    AccountCategory,
    AccountPrivacy,
    AccountStatus,
    VerificationTier,
)

USERNAME_PATTERN = re.compile(r"^[a-z0-9._]{3,24}$")


def sanitize_username_base(display_name: str, sim_id: int) -> str:
    """Build a deterministic lowercase handle stem from a Sim's display name."""
    raw = (display_name or "").strip().lower()
    parts = [re.sub(r"[^a-z0-9]", "", p) for p in raw.split()]
    parts = [p for p in parts if p]
    if len(parts) >= 2:
        base = "{}.{}".format(parts[0], parts[1])
    elif len(parts) == 1:
        base = parts[0]
    else:
        base = "sim{}".format(abs(int(sim_id)) % 100000)

    base = re.sub(r"\.{2,}", ".", base).strip(".")
    if len(base) < 3:
        base = (base + "sim")[:3] + str(abs(int(sim_id)) % 100)
    return base[:20]


class AccountManager(object):
    """Manages Social Bunny Verified accounts keyed by persistent Sim ID."""

    def __init__(self) -> None:
        self._accounts: Dict[str, Dict[str, Any]] = {}
        self._username_index: Dict[str, str] = {}

    def load_dict(self, data: Dict[str, Any]) -> None:
        self._accounts = {}
        self._username_index = {}
        if not isinstance(data, dict):
            return
        for sid, acc in data.items():
            if not isinstance(acc, dict):
                continue
            key = str(sid)
            copied = dict(acc)
            copied.setdefault("account_id", "sbv_{}".format(key))
            copied.setdefault("sim_id", key)
            copied.setdefault("username", "sim_{}".format(key))
            copied.setdefault("display_name", "Sim {}".format(key))
            copied.setdefault("bio", "")
            copied.setdefault("avatar_seed", key)
            copied.setdefault("category", AccountCategory.PERSONAL)
            copied.setdefault("privacy", AccountPrivacy.PUBLIC)
            copied.setdefault("verification_tier", VerificationTier.NONE)
            copied.setdefault("verified_at", 0)
            copied.setdefault("created_at", 0)
            copied.setdefault("reputation", 55.0)
            copied.setdefault("status", AccountStatus.ACTIVE)
            copied.setdefault("restriction_until", 0)
            copied.setdefault("suspension_until", 0)
            copied.setdefault("badge_suspended", False)
            copied.setdefault("is_npc", False)
            copied.setdefault("traits", [])
            copied.setdefault("career", "")
            copied.setdefault("fame_level", 0)
            copied.setdefault("notify_likes", True)
            copied.setdefault("notify_comments", True)
            copied.setdefault("notify_follows", True)
            copied.setdefault("profile_visits", 0)
            copied.setdefault("native_followers_offset", 0)
            self._accounts[key] = copied
            self._username_index[copied["username"].lower()] = key

    def to_dict(self) -> Dict[str, Any]:
        return {k: dict(v) for k, v in self._accounts.items()}

    def get_account(self, sim_id: Any) -> Optional[Dict[str, Any]]:
        return self._accounts.get(str(sim_id))

    def get_by_username(self, username: str) -> Optional[Dict[str, Any]]:
        if not username:
            return None
        clean = username.strip().lstrip("@").lower()
        sid = self._username_index.get(clean)
        if sid is None:
            return None
        return self._accounts.get(sid)

    def all_accounts(self) -> List[Dict[str, Any]]:
        return list(self._accounts.values())

    def has_account(self, sim_id: Any) -> bool:
        return str(sim_id) in self._accounts

    def ensure_account(
        self,
        sim_id: Any,
        display_name: str = "",
        now_ticks: int = 0,
        is_npc: Optional[bool] = None,
        traits: Optional[List[str]] = None,
        career: str = "",
        fame_level: Optional[int] = None,
        category: Optional[str] = None,
    ) -> Dict[str, Any]:
        """Lazily create or refresh basic Sim identity metadata."""
        key = str(sim_id)
        existing = self._accounts.get(key)
        if existing is not None:
            if display_name and existing.get("display_name", "").startswith("Sim "):
                existing["display_name"] = display_name
            elif display_name and existing.get("display_name") != display_name:
                existing["display_name"] = display_name
            if traits is not None:
                existing["traits"] = list(traits)
            if career:
                existing["career"] = career
            if fame_level is not None:
                existing["fame_level"] = int(fame_level)
            if is_npc is not None:
                existing["is_npc"] = bool(is_npc)
            return existing

        name_str = display_name.strip() if display_name else "Sim {}".format(key)
        username = self._allocate_unique_username(name_str, int(sim_id) if str(sim_id).isdigit() else 0)
        resolved_category = category if category in AccountCategory.ALL else AccountCategory.PERSONAL
        if category is None and int(fame_level or 0) >= 2:
            resolved_category = AccountCategory.PUBLIC_FIGURE

        account = {
            "account_id": "sbv_{}".format(key),
            "sim_id": key,
            "username": username,
            "display_name": name_str,
            "bio": "",
            "avatar_seed": key,
            "category": resolved_category,
            "privacy": AccountPrivacy.PUBLIC,
            "verification_tier": VerificationTier.NONE,
            "verified_at": 0,
            "created_at": int(now_ticks),
            "reputation": 55.0 + min(15.0, float(fame_level or 0) * 3.0),
            "status": AccountStatus.ACTIVE,
            "restriction_until": 0,
            "suspension_until": 0,
            "badge_suspended": False,
            "is_npc": bool(is_npc),
            "traits": list(traits or []),
            "career": career or "",
            "fame_level": int(fame_level or 0),
            "notify_likes": True,
            "notify_comments": True,
            "notify_follows": True,
            "profile_visits": 0,
            "native_followers_offset": 0,
        }
        self._accounts[key] = account
        self._username_index[username.lower()] = key
        return account

    def _allocate_unique_username(self, display_name: str, sim_id: int) -> str:
        base = sanitize_username_base(display_name, sim_id)
        candidate = base
        suffix = 2
        while candidate.lower() in self._username_index:
            suffix_str = str(suffix)
            candidate = "{}{}".format(base[: 24 - len(suffix_str)], suffix_str)
            suffix += 1
        return candidate

    def change_username(self, sim_id: Any, new_username: str) -> Dict[str, Any]:
        """Validate and update a Sim's handle cleanly."""
        acc = self.get_account(sim_id)
        if acc is None:
            return {"ok": False, "error": "Account not found."}
        clean = (new_username or "").strip().lstrip("@").lower()
        if not USERNAME_PATTERN.match(clean):
            return {
                "ok": False,
                "error": "Username must be 3-24 chars using a-z, 0-9, '.' or '_'.",
            }
        if clean.startswith(".") or clean.endswith(".") or ".." in clean:
            return {"ok": False, "error": "Username cannot start, end, or repeat dots."}

        owner = self._username_index.get(clean)
        if owner is not None and owner != str(sim_id):
            return {"ok": False, "error": "Username @{} is already taken.".format(clean)}

        old = acc["username"].lower()
        if old in self._username_index and self._username_index[old] == str(sim_id):
            del self._username_index[old]
        acc["username"] = clean
        self._username_index[clean] = str(sim_id)
        return {"ok": True, "username": clean}

    def set_category(self, sim_id: Any, category: str) -> Dict[str, Any]:
        acc = self.get_account(sim_id)
        if acc is None:
            return {"ok": False, "error": "Account not found."}
        if category not in AccountCategory.ALL:
            return {"ok": False, "error": "Invalid account category."}
        acc["category"] = category
        return {"ok": True, "category": category}

    def set_privacy(self, sim_id: Any, privacy: str) -> Dict[str, Any]:
        acc = self.get_account(sim_id)
        if acc is None:
            return {"ok": False, "error": "Account not found."}
        if privacy not in AccountPrivacy.ALL:
            return {"ok": False, "error": "Invalid privacy mode."}
        acc["privacy"] = privacy
        return {"ok": True, "privacy": privacy}

    def update_notification_prefs(
        self,
        sim_id: Any,
        notify_likes: Optional[bool] = None,
        notify_comments: Optional[bool] = None,
        notify_follows: Optional[bool] = None,
    ) -> bool:
        acc = self.get_account(sim_id)
        if acc is None:
            return False
        if notify_likes is not None:
            acc["notify_likes"] = bool(notify_likes)
        if notify_comments is not None:
            acc["notify_comments"] = bool(notify_comments)
        if notify_follows is not None:
            acc["notify_follows"] = bool(notify_follows)
        return True

    def get_effective_badge(self, acc: Optional[Dict[str, Any]]) -> str:
        """Return visible badge tier taking suspension/revocation into account."""
        if not acc:
            return VerificationTier.NONE
        if acc.get("status") == AccountStatus.SUSPENDED or acc.get("badge_suspended"):
            return VerificationTier.NONE
        tier = acc.get("verification_tier", VerificationTier.NONE)
        if tier != VerificationTier.NONE:
            return tier
        # Creator category carries its distinct creator badge when not verified
        if acc.get("category") == AccountCategory.CREATOR:
            return VerificationTier.CREATOR
        return VerificationTier.NONE

    def is_verified_blue_or_official(self, acc: Optional[Dict[str, Any]]) -> bool:
        if not acc or acc.get("badge_suspended") or acc.get("status") == AccountStatus.SUSPENDED:
            return False
        return acc.get("verification_tier") in (
            VerificationTier.BLUE_VERIFIED,
            VerificationTier.OFFICIAL,
            VerificationTier.LEGACY,
        )

    def remove_account(self, sim_id: Any) -> None:
        key = str(sim_id)
        acc = self._accounts.pop(key, None)
        if acc:
            uname = acc.get("username", "").lower()
            if self._username_index.get(uname) == key:
                del self._username_index[uname]
