# -*- coding: utf-8 -*-
"""Bounded subscription notifications and last-action results."""

MAX_NOTIFICATIONS_PER_SIM = 30


class VerifiedNotificationService(object):
    def __init__(self, adapter, persistence):
        self._adapter = adapter
        self._persistence = persistence
        self._payload = None

    def bind(self, payload):
        self._payload = payload

    def _meta(self):
        if self._payload is None:
            return {"next_sequence": 1}
        return self._payload.setdefault("meta", {"next_sequence": 1})

    def _next_id(self, prefix):
        meta = self._meta()
        try:
            seq = int(meta.get("next_sequence", 1))
        except Exception:
            seq = 1
        meta["next_sequence"] = seq + 1
        return "{}_{}".format(prefix, seq)

    def push(self, sim_id, kind, message, now_ticks, read=False):
        if self._payload is None:
            return None
        sid = str(sim_id)
        notifications = self._payload.setdefault("notifications", {})
        items = notifications.setdefault(sid, [])
        item = {
            "id": self._next_id("vn"),
            "kind": str(kind),
            "message": str(message)[:240],
            "tick": int(now_ticks),
            "date_label": self._adapter.format_sim_time(now_ticks),
            "read": bool(read),
        }
        items.insert(0, item)
        del items[MAX_NOTIFICATIONS_PER_SIM:]
        self._persistence.mark_dirty()
        return item

    def set_last_result(self, sim_id, ok, message, code="", kind="info", now_ticks=0):
        if self._payload is None:
            return None
        sid = str(sim_id)
        result = {
            "ok": bool(ok),
            "message": str(message)[:300],
            "code": str(code),
            "kind": str(kind),
            "tick": int(now_ticks),
        }
        self._payload.setdefault("last_results", {})[sid] = result
        self._persistence.mark_dirty()
        return result

    def get_last_result(self, sim_id):
        if self._payload is None:
            return None
        return self._payload.get("last_results", {}).get(str(sim_id))

    def get_for_sim(self, sim_id, limit=8):
        if self._payload is None:
            return []
        items = self._payload.get("notifications", {}).get(str(sim_id), [])
        return list(items[: max(0, int(limit))])

    def get_unread_count(self, sim_id):
        return sum(1 for item in self.get_for_sim(sim_id, 99) if not item.get("read", False))

    def mark_all_read(self, sim_id):
        count = 0
        if self._payload is None:
            return 0
        for item in self._payload.get("notifications", {}).get(str(sim_id), []):
            if not item.get("read", False):
                item["read"] = True
                count += 1
        if count:
            self._persistence.mark_dirty()
        return count
