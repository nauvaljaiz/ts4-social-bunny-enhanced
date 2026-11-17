# -*- coding: utf-8 -*-
"""Stable Social Bunny account identity for subscription records."""

import re


class VerifiedAccountService(object):
    def __init__(self, adapter, persistence):
        self._adapter = adapter
        self._persistence = persistence
        self._payload = None

    def bind(self, payload):
        self._payload = payload

    def _accounts(self):
        if self._payload is None:
            return {}
        return self._payload.setdefault("accounts", {})

    def get_account(self, sim_id):
        return self._accounts().get(str(sim_id))

    def ensure_account(self, sim_id, now_ticks=0):
        sid = str(sim_id)
        accounts = self._accounts()
        record = accounts.get(sid)
        display_name = self._adapter.get_display_name(sid)
        is_player = self._adapter.is_player_sim(sid)

        if record is None:
            record = {
                "account_id": "sba_{}".format(sid),
                "sim_id": sid,
                "username": self._allocate_username(display_name, sid),
                "display_name": display_name,
                "created_at": int(now_ticks),
                "is_npc": not bool(is_player),
            }
            accounts[sid] = record
            self._persistence.mark_dirty()
        else:
            record.setdefault("account_id", "sba_{}".format(sid))
            record.setdefault("sim_id", sid)
            record.setdefault("username", self._allocate_username(display_name, sid))
            record["display_name"] = display_name
            record["is_npc"] = not bool(is_player)
        return record

    def get_account_id(self, sim_id):
        account = self.ensure_account(sim_id)
        return account["account_id"]

    def get_username(self, sim_id):
        account = self.ensure_account(sim_id)
        return account["username"]

    def _allocate_username(self, display_name, sim_id):
        base = self._sanitize(display_name, sim_id)
        accounts = self._accounts()
        used = {
            str(item.get("username", "")).lower()
            for item in accounts.values()
            if isinstance(item, dict)
        }
        candidate = base
        suffix = 2
        while candidate.lower() in used:
            suffix_text = str(suffix)
            candidate = "{}{}".format(base[: max(1, 24 - len(suffix_text))], suffix_text)
            suffix += 1
        return candidate

    def _sanitize(self, display_name, sim_id):
        raw = str(display_name or "").strip().lower()
        parts = [re.sub(r"[^a-z0-9]", "", part) for part in raw.split()]
        parts = [part for part in parts if part]
        if len(parts) >= 2:
            base = "{}.{}".format(parts[0], parts[1])
        elif len(parts) == 1:
            base = parts[0]
        else:
            base = "sim{}".format(str(sim_id))
        base = re.sub(r"\.{2,}", ".", base).strip(".")
        if len(base) < 3:
            base = (base + "sim")[:3] + str(abs(int(sim_id)) % 100 if str(sim_id).isdigit() else 0)
        return base[:20]
