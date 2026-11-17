# -*- coding: utf-8 -*-
"""Bounded per-Sim platform notifications and unread tracking."""

from typing import Any, Dict, List

from .models import NotificationType


class NotificationManager(object):
    """Stores platform notifications per Sim with bounded history."""

    MAX_PER_SIM = 60

    def __init__(self) -> None:
        self._notifications: Dict[str, List[Dict[str, Any]]] = {}
        self._next_seq: int = 1

    def load_dict(self, data: Dict[str, Any]) -> None:
        self._notifications = {}
        if not isinstance(data, dict):
            return
        self._next_seq = int(data.get("next_seq", 1))
        raw = data.get("items", {})
        if isinstance(raw, dict):
            for sid, lst in raw.items():
                if isinstance(lst, list):
                    self._notifications[str(sid)] = [dict(x) for x in lst if isinstance(x, dict)][-self.MAX_PER_SIM :]

    def to_dict(self) -> Dict[str, Any]:
        return {
            "next_seq": self._next_seq,
            "items": {k: list(v) for k, v in self._notifications.items() if v},
        }

    def push(
        self,
        recipient_sim_id: Any,
        notif_type: str,
        actor_sim_id: Any,
        message: str,
        now_ticks: int = 0,
        ref_id: str = "",
    ) -> Dict[str, Any]:
        r_key = str(recipient_sim_id)
        nid = "n_{}".format(self._next_seq)
        self._next_seq += 1
        item = {
            "id": nid,
            "type": notif_type,
            "actor_sim_id": str(actor_sim_id),
            "message": str(message)[:180],
            "tick": int(now_ticks),
            "ref_id": str(ref_id or ""),
            "read": False,
        }
        lst = self._notifications.setdefault(r_key, [])
        lst.insert(0, item)
        if len(lst) > self.MAX_PER_SIM:
            del lst[self.MAX_PER_SIM :]
        return item

    def get_for_sim(self, sim_id: Any) -> List[Dict[str, Any]]:
        return list(self._notifications.get(str(sim_id), ()))

    def get_unread_count(self, sim_id: Any) -> int:
        return sum(1 for n in self._notifications.get(str(sim_id), ()) if not n.get("read"))

    def mark_all_read(self, sim_id: Any) -> int:
        count = 0
        for n in self._notifications.get(str(sim_id), ()):
            if not n.get("read"):
                n["read"] = True
                count += 1
        return count

    def purge_sim(self, sim_id: Any) -> None:
        self._notifications.pop(str(sim_id), None)
