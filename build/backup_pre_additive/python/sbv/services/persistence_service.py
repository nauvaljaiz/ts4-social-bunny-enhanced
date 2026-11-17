# -*- coding: utf-8 -*-
"""Save-slot isolated persistent storage, schema migration, and integrity checks."""

import json
import os
import shutil
from typing import Any, Callable, Dict, Optional, Set

from ..core.models import SCHEMA_VERSION


class PersistenceService(object):
    """Handles atomic save-slot JSON persistence with backup recovery and validation."""

    def __init__(self, data_dir: Optional[str] = None) -> None:
        self._data_dir = data_dir or self._resolve_default_data_dir()
        self._active_slot_id: Optional[int] = None
        self._dirty: bool = False

    def _resolve_default_data_dir(self) -> str:
        # Store inside Documents/Electronic Arts/The Sims 4/Mods/SocialBunnyVerified_Data
        # or fallback to local module directory when running in offline unit tests
        try:
            home = os.path.expanduser("~")
            ea_mods = os.path.join(home, "Documents", "Electronic Arts", "The Sims 4", "Mods")
            if os.path.isdir(ea_mods):
                target = os.path.join(ea_mods, "SocialBunnyVerified_Data")
                os.makedirs(target, exist_ok=True)
                return target
        except Exception:
            pass
        fallback = os.path.join(os.path.dirname(os.path.abspath(__file__)), "save_data")
        os.makedirs(fallback, exist_ok=True)
        return fallback

    def get_slot_file_path(self, slot_id: int) -> str:
        return os.path.join(self._data_dir, "sbv_data_slot_{}.json".format(int(slot_id)))

    def get_active_slot_id(self) -> int:
        try:
            import services
            ps = services.get_persistence_service()
            if ps is not None:
                proto = ps.get_save_slot_proto_buff()
                if proto is not None and hasattr(proto, "slot_id"):
                    return int(proto.slot_id)
        except Exception:
            pass
        return self._active_slot_id if self._active_slot_id is not None else 0

    def mark_dirty(self) -> None:
        self._dirty = True

    def is_dirty(self) -> bool:
        return self._dirty

    def load_slot(self, slot_id: Optional[int] = None) -> Dict[str, Any]:
        sid = int(slot_id) if slot_id is not None else self.get_active_slot_id()
        self._active_slot_id = sid
        path = self.get_slot_file_path(sid)
        bak_path = path + ".bak"

        raw_data = self._try_read_json(path)
        if raw_data is None and os.path.isfile(bak_path):
            raw_data = self._try_read_json(bak_path)

        if raw_data is None:
            return self.empty_payload()
        return self.migrate_payload(raw_data)

    def _try_read_json(self, path: str) -> Optional[Dict[str, Any]]:
        if not os.path.isfile(path):
            return None
        try:
            with open(path, "r", encoding="utf-8") as f:
                obj = json.load(f)
            if isinstance(obj, dict):
                return obj
        except Exception:
            return None
        return None

    def empty_payload(self) -> Dict[str, Any]:
        return {
            "schema_version": SCHEMA_VERSION,
            "accounts": {},
            "social_graph": {},
            "posts_data": {"next_post_seq": 1, "next_comment_seq": 1, "posts": []},
            "engagement": {"daily_snapshots": {}},
            "verification": {"next_app_seq": 1, "applications": {}, "history": {}},
            "reputation": {},
            "moderation": {"next_report_seq": 1, "reports": [], "mod_log": {}},
            "notifications": {"next_seq": 1, "items": {}},
            "brands": {"next_offer_seq": 1, "offers": {}},
        }

    def migrate_payload(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Upgrade older save payloads cleanly and recover missing top-level keys."""
        base = self.empty_payload()
        version = int(data.get("schema_version", 1))
        for key in base:
            if key == "schema_version":
                continue
            if isinstance(data.get(key), dict):
                base[key] = data[key]
        base["schema_version"] = max(SCHEMA_VERSION, version)
        return base

    def save_slot(self, payload: Dict[str, Any], slot_id: Optional[int] = None) -> bool:
        sid = int(slot_id) if slot_id is not None else self.get_active_slot_id()
        self._active_slot_id = sid
        os.makedirs(self._data_dir, exist_ok=True)
        path = self.get_slot_file_path(sid)
        tmp_path = path + ".tmp"
        bak_path = path + ".bak"

        out = dict(payload)
        out["schema_version"] = SCHEMA_VERSION
        try:
            with open(tmp_path, "w", encoding="utf-8") as f:
                json.dump(out, f, ensure_ascii=False, separators=(",", ":"))
            if os.path.isfile(path):
                try:
                    shutil.copy2(path, bak_path)
                except Exception:
                    pass
            os.replace(tmp_path, path)
            self._dirty = False
            return True
        except Exception:
            try:
                if os.path.isfile(tmp_path):
                    os.remove(tmp_path)
            except Exception:
                pass
            return False

    def sanitize_deleted_sims(
        self,
        account_manager: Any,
        follower_manager: Any,
        post_manager: Any,
        notification_manager: Any,
        sim_exists_fn: Callable[[int], bool],
    ) -> int:
        """Purge dangling references to deleted Sims safely."""
        removed = 0
        for acc in list(account_manager.all_accounts()):
            sid_str = str(acc.get("sim_id", ""))
            if not sid_str.isdigit():
                continue
            if not sim_exists_fn(int(sid_str)):
                account_manager.remove_account(sid_str)
                follower_manager.purge_sim(sid_str)
                post_manager.purge_sim(sid_str)
                notification_manager.purge_sim(sid_str)
                removed += 1
        return removed
