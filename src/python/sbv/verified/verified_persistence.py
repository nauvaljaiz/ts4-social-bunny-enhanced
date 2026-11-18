# -*- coding: utf-8 -*-
"""Versioned save-slot persistence for Social Bunny Verified subscriptions."""

import json
import os
import shutil

SCHEMA_VERSION = 2


def _as_dict(value):
    return value if isinstance(value, dict) else {}


class VerifiedPersistence(object):
    """Atomic JSON persistence isolated per save slot, with .bak recovery."""

    def __init__(self, data_dir=None):
        self._data_dir = data_dir or self._resolve_default_data_dir()
        self._active_slot_id = None
        self._dirty = False
        self._last_error = ""

    def _resolve_default_data_dir(self):
        try:
            home = os.path.expanduser("~")
            mods_dir = os.path.join(home, "Documents", "Electronic Arts", "The Sims 4", "Mods")
            if os.path.isdir(mods_dir):
                target = os.path.join(mods_dir, "SocialBunnyVerified_Data")
                os.makedirs(target, exist_ok=True)
                return target
        except Exception:
            pass
        fallback = os.path.join(os.path.dirname(os.path.abspath(__file__)), "save_data")
        os.makedirs(fallback, exist_ok=True)
        return fallback

    @property
    def data_dir(self):
        return self._data_dir

    def get_slot_file_path(self, slot_id):
        return os.path.join(self._data_dir, "verified_subscriptions_slot_{}.json".format(int(slot_id)))

    def get_slot_file_path_for_active(self):
        return self.get_slot_file_path(self._active_slot_id if self._active_slot_id is not None else 0)

    def mark_dirty(self):
        self._dirty = True

    def is_dirty(self):
        return self._dirty

    def set_active_slot_id(self, slot_id):
        self._active_slot_id = int(slot_id)

    @property
    def active_slot_id(self):
        return self._active_slot_id

    @property
    def last_error(self):
        return self._last_error

    def empty_payload(self):
        return {
            "schema_version": SCHEMA_VERSION,
            "subscriptions": {},
            "accounts": {},
            "notifications": {},
            "last_results": {},
            "meta": {
                "next_sequence": 1,
                "created_tick": 0,
                "last_saved_tick": 0,
            },
        }

    def load_slot(self, slot_id):
        sid = int(slot_id)
        self._active_slot_id = sid
        path = self.get_slot_file_path(sid)
        backup = path + ".bak"

        data = self._try_read_json(path)
        recovered = False
        if data is None and os.path.isfile(backup):
            data = self._try_read_json(backup)
            recovered = bool(data is not None)
        if data is None:
            return self.empty_payload()

        payload = self.migrate_payload(data)
        if recovered:
            self.mark_dirty()
        return payload

    def _try_read_json(self, path):
        if not os.path.isfile(path):
            return None
        try:
            with open(path, "r", encoding="utf-8") as handle:
                data = json.load(handle)
            if isinstance(data, dict):
                return data
        except Exception:
            return None
        return None

    def migrate_payload(self, data):
        """Upgrade older payloads without deleting unknown account data."""
        base = self.empty_payload()
        if not isinstance(data, dict):
            return base

        version = 0
        try:
            version = int(data.get("schema_version", 0))
        except Exception:
            version = 0

        subscriptions = data.get("subscriptions")
        if isinstance(subscriptions, list):
            subscriptions = {
                str(item.get("sim_id", index)): item
                for index, item in enumerate(subscriptions)
                if isinstance(item, dict)
            }
        base["subscriptions"] = _as_dict(subscriptions)
        base["accounts"] = _as_dict(data.get("accounts"))
        base["notifications"] = _as_dict(data.get("notifications"))
        base["last_results"] = _as_dict(data.get("last_results"))

        meta = dict(base["meta"])
        meta.update(_as_dict(data.get("meta")))
        try:
            meta["next_sequence"] = max(1, int(meta.get("next_sequence", 1)))
        except Exception:
            meta["next_sequence"] = 1
        base["meta"] = meta

        # Normalize every subscription so old records have safe defaults.
        for sim_id, record in list(base["subscriptions"].items()):
            if not isinstance(record, dict):
                base["subscriptions"].pop(sim_id, None)
                continue
            record.setdefault("subscription_id", "")
            record.setdefault("sim_id", str(sim_id))
            record.setdefault("account_id", "sba_{}".format(sim_id))
            record.setdefault("plan_id", "social_bunny_verified")
            record.setdefault("plan_name", "Social Bunny Verified")
            record.setdefault("status", "not_subscribed")
            record.setdefault("start_date", 0)
            record.setdefault("current_period_start", 0)
            record.setdefault("current_period_end", 0)
            record.setdefault("next_billing_at", 0)
            record.setdefault("last_successful_payment", 0)
            record.setdefault("payment_amount", 0)
            record.setdefault("auto_renew", False)
            record.setdefault("cancellation_timestamp", 0)
            record.setdefault("expiration_timestamp", 0)
            record.setdefault("grace_period_end", 0)
            record.setdefault("last_failure_at", 0)
            record.setdefault("last_failure_reason", "")
            record.setdefault("retry_count", 0)
            record.setdefault("reminder_sent_for", 0)
            record.setdefault("pending_payout", 0)
            record.setdefault("total_earnings", 0)
            record.setdefault("total_bonus_followers", 0)
            record.setdefault("boost_count", 0)
            record.setdefault("last_boost_at", 0)
            record.setdefault("boost_active", False)
            record.setdefault("boost_started_at", 0)
            record.setdefault("boost_ends_at", 0)
            record.setdefault("boost_ticks_done", 0)
            record.setdefault("boost_total_ticks", 4)
            record.setdefault("boost_followers_gained", 0)
            record.setdefault("boost_payout_gained", 0)
            record.setdefault("boost_reactions_gained", 0)
            record.setdefault("welcome_bonus_granted_at", 0)
            record.setdefault("payment_history", [])
            if not isinstance(record.get("payment_history"), list):
                record["payment_history"] = []
            record.setdefault("tier", "creator_blue")
            record.setdefault("contracts", [])
            record.setdefault("contract_lock_until", 0)
            record.setdefault("active_strikes", 0)
            record.setdefault("credibility_score", 65)
            record.setdefault("brand_safety_score", 80)
            record.setdefault("social_battery", 100.0)
            record.setdefault("dm_pair_history", {})
            record.setdefault("audience_segments", {
                "core_loyalists": 40,
                "casual_browsers": 35,
                "drama_vultures": 15,
                "anti_fans": 10,
            })
            record.setdefault("post_categories", [])
            record.setdefault("cancelation_state", "NORMAL")
            record.setdefault("comment_threads", [])
            record.setdefault("purge_times_24h", [])

        for key, value in data.items():
            if key not in base:
                base[key] = value

        base["schema_version"] = max(SCHEMA_VERSION, version if version > 0 else SCHEMA_VERSION)
        return base

    def save_slot(self, payload, slot_id=None):
        sid = int(slot_id) if slot_id is not None else int(self._active_slot_id or 0)
        self._active_slot_id = sid
        try:
            os.makedirs(self._data_dir, exist_ok=True)
        except Exception as exc:
            self._last_error = str(exc)
            return False

        path = self.get_slot_file_path(sid)
        tmp_path = path + ".tmp"
        backup_path = path + ".bak"

        out = dict(payload)
        out["schema_version"] = SCHEMA_VERSION
        try:
            with open(tmp_path, "w", encoding="utf-8") as handle:
                json.dump(out, handle, ensure_ascii=False, separators=(",", ":"))
            if os.path.isfile(path):
                try:
                    shutil.copy2(path, backup_path)
                except Exception:
                    pass
            os.replace(tmp_path, path)
            self._dirty = False
            self._last_error = ""
            return True
        except Exception as exc:
            self._last_error = str(exc)
            try:
                if os.path.isfile(tmp_path):
                    os.remove(tmp_path)
            except Exception:
                pass
            return False

    def delete_slot(self, slot_id):
        sid = int(slot_id)
        for suffix in ("", ".bak"):
            try:
                path = self.get_slot_file_path(sid) + suffix
                if os.path.isfile(path):
                    os.remove(path)
            except Exception:
                pass
