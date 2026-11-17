# -*- coding: utf-8 -*-
"""Sparse social graph for followers, following, requests, blocks, mutes, and restricts."""

from typing import Any, Dict, List, Set

from .models import AccountPrivacy


class FollowerManager(object):
    """Manages platform relationships independently from native Sim friendships."""

    def __init__(self) -> None:
        # Adjacency sets stored as {sim_id_str: [other_sim_id_str, ...]}
        self._following: Dict[str, List[str]] = {}
        self._followers: Dict[str, List[str]] = {}
        self._requests: Dict[str, List[str]] = {}  # target_sim_id -> [requester_sim_ids]
        self._blocked: Dict[str, List[str]] = {}
        self._restricted: Dict[str, List[str]] = {}
        self._muted: Dict[str, List[str]] = {}

    def load_dict(self, data: Dict[str, Any]) -> None:
        self._following = {}
        self._followers = {}
        self._requests = {}
        self._blocked = {}
        self._restricted = {}
        self._muted = {}
        if not isinstance(data, dict):
            return
        for attr, key in (
            (self._following, "following"),
            (self._followers, "followers"),
            (self._requests, "requests"),
            (self._blocked, "blocked"),
            (self._restricted, "restricted"),
            (self._muted, "muted"),
        ):
            raw = data.get(key, {})
            if isinstance(raw, dict):
                for owner, lst in raw.items():
                    if isinstance(lst, list):
                        # Deduplicate preserving order
                        seen: Set[str] = set()
                        clean: List[str] = []
                        for item in lst:
                            s = str(item)
                            if s not in seen and s != str(owner):
                                seen.add(s)
                                clean.append(s)
                        if clean:
                            attr[str(owner)] = clean
        # Rebuild _followers index symmetrically if missing
        for src, targets in self._following.items():
            for dst in targets:
                fl = self._followers.setdefault(dst, [])
                if src not in fl:
                    fl.append(src)

    def to_dict(self) -> Dict[str, Any]:
        return {
            "following": {k: list(v) for k, v in self._following.items() if v},
            "requests": {k: list(v) for k, v in self._requests.items() if v},
            "blocked": {k: list(v) for k, v in self._blocked.items() if v},
            "restricted": {k: list(v) for k, v in self._restricted.items() if v},
            "muted": {k: list(v) for k, v in self._muted.items() if v},
        }

    def is_following(self, follower_id: Any, target_id: Any) -> bool:
        return str(target_id) in self._following.get(str(follower_id), ())

    def has_pending_request(self, follower_id: Any, target_id: Any) -> bool:
        return str(follower_id) in self._requests.get(str(target_id), ())

    def is_blocked(self, owner_id: Any, other_id: Any) -> bool:
        return str(other_id) in self._blocked.get(str(owner_id), ())

    def is_restricted(self, owner_id: Any, other_id: Any) -> bool:
        return str(other_id) in self._restricted.get(str(owner_id), ())

    def is_muted(self, owner_id: Any, other_id: Any) -> bool:
        return str(other_id) in self._muted.get(str(owner_id), ())

    def get_followers(self, sim_id: Any) -> List[str]:
        return list(self._followers.get(str(sim_id), ()))

    def get_following(self, sim_id: Any) -> List[str]:
        return list(self._following.get(str(sim_id), ()))

    def get_pending_requests(self, sim_id: Any) -> List[str]:
        return list(self._requests.get(str(sim_id), ()))

    def get_blocked(self, sim_id: Any) -> List[str]:
        return list(self._blocked.get(str(sim_id), ()))

    def get_restricted(self, sim_id: Any) -> List[str]:
        return list(self._restricted.get(str(sim_id), ()))

    def get_muted(self, sim_id: Any) -> List[str]:
        return list(self._muted.get(str(sim_id), ()))

    def get_follower_count(self, sim_id: Any) -> int:
        return len(self._followers.get(str(sim_id), ()))

    def get_following_count(self, sim_id: Any) -> int:
        return len(self._following.get(str(sim_id), ()))

    def get_mutual_followers(self, sim_a: Any, sim_b: Any) -> List[str]:
        a_set = set(self.get_followers(sim_a))
        b_set = set(self.get_followers(sim_b))
        return sorted(a_set & b_set)

    def follow(self, follower_id: Any, target_id: Any, target_privacy: str = AccountPrivacy.PUBLIC) -> Dict[str, Any]:
        f_key = str(follower_id)
        t_key = str(target_id)
        if f_key == t_key:
            return {"ok": False, "status": "self"}
        if self.is_blocked(t_key, f_key) or self.is_blocked(f_key, t_key):
            return {"ok": False, "status": "blocked"}
        if self.is_following(f_key, t_key):
            return {"ok": True, "status": "already_following"}
        if target_privacy == AccountPrivacy.PRIVATE:
            reqs = self._requests.setdefault(t_key, [])
            if f_key not in reqs:
                reqs.append(f_key)
            return {"ok": True, "status": "requested"}
        self._add_follow_edge(f_key, t_key)
        return {"ok": True, "status": "following"}

    def _add_follow_edge(self, follower_id: str, target_id: str) -> None:
        fg = self._following.setdefault(follower_id, [])
        if target_id not in fg:
            fg.append(target_id)
        fl = self._followers.setdefault(target_id, [])
        if follower_id not in fl:
            fl.append(follower_id)
        reqs = self._requests.get(target_id)
        if reqs and follower_id in reqs:
            reqs.remove(follower_id)

    def unfollow(self, follower_id: Any, target_id: Any) -> bool:
        f_key = str(follower_id)
        t_key = str(target_id)
        changed = False
        fg = self._following.get(f_key)
        if fg and t_key in fg:
            fg.remove(t_key)
            changed = True
        fl = self._followers.get(t_key)
        if fl and f_key in fl:
            fl.remove(f_key)
            changed = True
        reqs = self._requests.get(t_key)
        if reqs and f_key in reqs:
            reqs.remove(f_key)
            changed = True
        return changed

    def approve_request(self, target_id: Any, requester_id: Any) -> bool:
        t_key = str(target_id)
        r_key = str(requester_id)
        reqs = self._requests.get(t_key)
        if not reqs or r_key not in reqs:
            return False
        reqs.remove(r_key)
        self._add_follow_edge(r_key, t_key)
        return True

    def reject_request(self, target_id: Any, requester_id: Any) -> bool:
        t_key = str(target_id)
        r_key = str(requester_id)
        reqs = self._requests.get(t_key)
        if not reqs or r_key not in reqs:
            return False
        reqs.remove(r_key)
        return True

    def remove_follower(self, owner_id: Any, follower_id: Any) -> bool:
        return self.unfollow(follower_id, owner_id)

    def block(self, owner_id: Any, target_id: Any) -> bool:
        o_key = str(owner_id)
        t_key = str(target_id)
        if o_key == t_key:
            return False
        blk = self._blocked.setdefault(o_key, [])
        if t_key not in blk:
            blk.append(t_key)
        self.unfollow(o_key, t_key)
        self.unfollow(t_key, o_key)
        return True

    def unblock(self, owner_id: Any, target_id: Any) -> bool:
        o_key = str(owner_id)
        t_key = str(target_id)
        blk = self._blocked.get(o_key)
        if blk and t_key in blk:
            blk.remove(t_key)
            return True
        return False

    def toggle_restrict(self, owner_id: Any, target_id: Any) -> bool:
        return self._toggle_list(self._restricted, str(owner_id), str(target_id))

    def toggle_mute(self, owner_id: Any, target_id: Any) -> bool:
        return self._toggle_list(self._muted, str(owner_id), str(target_id))

    def _toggle_list(self, store: Dict[str, List[str]], owner_id: str, target_id: str) -> bool:
        if owner_id == target_id:
            return False
        lst = store.setdefault(owner_id, [])
        if target_id in lst:
            lst.remove(target_id)
            return False
        lst.append(target_id)
        return True

    def purge_sim(self, sim_id: Any) -> None:
        key = str(sim_id)
        for fg_target in list(self._following.pop(key, ())):
            fl = self._followers.get(fg_target)
            if fl and key in fl:
                fl.remove(key)
        for follower in list(self._followers.pop(key, ())):
            fg = self._following.get(follower)
            if fg and key in fg:
                fg.remove(key)
        self._requests.pop(key, None)
        for reqs in self._requests.values():
            if key in reqs:
                reqs.remove(key)
        for store in (self._blocked, self._restricted, self._muted):
            store.pop(key, None)
            for lst in store.values():
                if key in lst:
                    lst.remove(key)
