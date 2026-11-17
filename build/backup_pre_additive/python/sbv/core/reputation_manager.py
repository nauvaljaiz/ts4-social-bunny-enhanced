# -*- coding: utf-8 -*-
"""Platform reputation scoring and cascading social controversy engine."""

import random
from typing import Any, Dict, List


class ReputationManager(object):
    """Tracks Sim reputation and orchestrates social controversy consequence chains."""

    MIN_REP = 0.0
    MAX_REP = 100.0

    def __init__(self) -> None:
        self._events: Dict[str, List[Dict[str, Any]]] = {}

    def load_dict(self, data: Dict[str, Any]) -> None:
        self._events = {}
        if not isinstance(data, dict):
            return
        for sid, items in data.items():
            if isinstance(items, list):
                self._events[str(sid)] = [dict(x) for x in items if isinstance(x, dict)][-30:]

    def to_dict(self) -> Dict[str, Any]:
        return {k: list(v) for k, v in self._events.items() if v}

    def get_history(self, sim_id: Any) -> List[Dict[str, Any]]:
        return list(self._events.get(str(sim_id), ()))

    def adjust_reputation(
        self,
        account: Dict[str, Any],
        delta: float,
        reason: str,
        now_ticks: int = 0,
    ) -> float:
        old = float(account.get("reputation", 55.0))
        new_val = round(max(self.MIN_REP, min(self.MAX_REP, old + float(delta))), 2)
        account["reputation"] = new_val
        s_key = str(account["sim_id"])
        hist = self._events.setdefault(s_key, [])
        hist.append({
            "delta": round(new_val - old, 2),
            "new_score": new_val,
            "reason": reason,
            "tick": int(now_ticks),
        })
        if len(hist) > 30:
            del hist[:-30]
        return new_val

    def get_standing_label(self, score: float) -> str:
        if score >= 85.0:
            return "Iconic"
        if score >= 65.0:
            return "Trusted"
        if score >= 45.0:
            return "Neutral"
        if score >= 25.0:
            return "Controversial"
        return "At Risk"

    def trigger_controversy_chain(
        self,
        account: Dict[str, Any],
        post: Dict[str, Any],
        all_accounts: List[Dict[str, Any]],
        post_manager: Any,
        follower_manager: Any,
        now_ticks: int = 0,
    ) -> Dict[str, Any]:
        """
        Execute a realistic controversy cascade:
        1. Post controversy level rises -> unusual impression/reach surge.
        2. Polarized NPC comments appear.
        3. Reputation drops according to severity.
        4. Follower churn: some unfollow, a few curiosity-follow.
        """
        s_key = str(account["sim_id"])
        post["controversy_level"] = int(post.get("controversy_level", 0)) + 1
        post["impressions"] = int(post.get("impressions", 1)) + random.randint(15, 45)

        pool = [a for a in all_accounts if str(a["sim_id"]) != s_key and not follower_manager.is_blocked(s_key, a["sim_id"])]
        random.shuffle(pool)
        reactors = pool[: min(5, len(pool))]

        critical_lines = [
            "Wait, did you seriously just post this?!",
            "This is a terrible take. Unfollowing.",
            "Not a good look for someone with your platform...",
        ]
        supportive_lines = [
            "Honestly, someone finally said it out loud!",
            "Here for the drama honestly.",
            "People are overreacting, stay strong.",
        ]

        added_comments = []
        for idx, npc in enumerate(reactors):
            nid = str(npc["sim_id"])
            post_manager.record_view(post["post_id"], nid)
            if idx % 3 == 0:
                res = post_manager.add_comment(
                    post["post_id"], nid, random.choice(supportive_lines), now_ticks=now_ticks, polarity="positive"
                )
                post_manager.add_like(post["post_id"], nid)
            else:
                res = post_manager.add_comment(
                    post["post_id"], nid, random.choice(critical_lines), now_ticks=now_ticks, polarity="negative"
                )
            if res.get("ok"):
                added_comments.append(res["comment"])

        # Follower shifts
        followers = follower_manager.get_followers(s_key)
        unfollowed = 0
        for fid in list(followers)[:3]:
            if random.random() < 0.6:
                follower_manager.unfollow(fid, s_key)
                unfollowed += 1
        gained = 0
        for npc in pool[len(reactors) : len(reactors) + 2]:
            if random.random() < 0.4:
                res_f = follower_manager.follow(npc["sim_id"], s_key, account.get("privacy", "public"))
                if res_f.get("status") == "following":
                    gained += 1

        rep_delta = -8.5 if account.get("verification_tier", "none") != "none" else -5.5
        new_rep = self.adjust_reputation(account, rep_delta, "Public controversy on post {}".format(post["post_id"]), now_ticks)

        return {
            "comments_added": len(added_comments),
            "unfollowed": unfollowed,
            "gained": gained,
            "new_reputation": new_rep,
            "rep_delta": rep_delta,
        }
