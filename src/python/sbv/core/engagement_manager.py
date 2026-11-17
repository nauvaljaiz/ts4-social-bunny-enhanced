# -*- coding: utf-8 -*-
"""Real-activity engagement metrics, period filtering, and daily snapshots."""

from typing import Any, Dict, List, Optional

from .models import DEFAULT_ENGAGEMENT_CONFIG

TICKS_PER_SIM_DAY = 24 * 60


class EngagementManager(object):
    """Computes authentic engagement metrics and maintains per-Sim daily snapshots."""

    def __init__(self, config: Optional[Dict[str, float]] = None) -> None:
        self.config = dict(DEFAULT_ENGAGEMENT_CONFIG)
        if config:
            self.config.update(config)
        # {sim_id: [{"day": int, "followers": int, "likes": int, "comments": int, "reach": int, "impressions": int}]}
        self._daily_snapshots: Dict[str, List[Dict[str, int]]] = {}

    def load_dict(self, data: Dict[str, Any]) -> None:
        self._daily_snapshots = {}
        if not isinstance(data, dict):
            return
        snaps = data.get("daily_snapshots", {})
        if isinstance(snaps, dict):
            for sid, arr in snaps.items():
                if isinstance(arr, list):
                    self._daily_snapshots[str(sid)] = [dict(x) for x in arr if isinstance(x, dict)][-90:]

    def to_dict(self) -> Dict[str, Any]:
        return {"daily_snapshots": {k: list(v) for k, v in self._daily_snapshots.items() if v}}

    def record_daily_snapshot(
        self,
        sim_id: Any,
        sim_day: int,
        followers: int,
        posts: List[Dict[str, Any]],
    ) -> None:
        s_key = str(sim_id)
        likes = sum(len(p.get("likes", ())) for p in posts)
        comments = sum(len(p.get("comments", ())) for p in posts)
        reach_set = set()
        impressions = 0
        for p in posts:
            reach_set.update(p.get("reach", ()))
            impressions += int(p.get("impressions", 0))
        arr = self._daily_snapshots.setdefault(s_key, [])
        entry = {
            "day": int(sim_day),
            "followers": int(followers),
            "likes": int(likes),
            "comments": int(comments),
            "reach": len(reach_set),
            "impressions": int(impressions),
        }
        if arr and arr[-1].get("day") == int(sim_day):
            arr[-1] = entry
        else:
            arr.append(entry)
        if len(arr) > 90:
            del arr[:-90]

    def get_snapshots(self, sim_id: Any, period_days: Optional[int] = None) -> List[Dict[str, int]]:
        arr = list(self._daily_snapshots.get(str(sim_id), ()))
        if period_days is not None and period_days > 0 and arr:
            max_day = arr[-1]["day"]
            min_day = max_day - period_days
            arr = [x for x in arr if x.get("day", 0) >= min_day]
        return arr

    def calculate_engagement_rate(
        self,
        likes: int,
        comments: int,
        shares: int,
        reach: int,
    ) -> float:
        """Compute engagement rate safely with zero-reach guard."""
        if reach <= 0:
            return 0.0
        weighted = (
            float(likes) * self.config["like_weight"]
            + float(comments) * self.config["comment_weight"]
            + float(shares) * self.config["share_weight"]
        )
        # Standard unweighted rate + weighted option: return standard formula percentage
        raw_total = float(likes + comments + shares)
        _ = weighted
        return round((raw_total / float(reach)) * 100.0, 2)

    def summarize_account(
        self,
        sim_id: Any,
        account: Dict[str, Any],
        posts: List[Dict[str, Any]],
        followers_count: int,
        following_count: int,
        now_ticks: int = 0,
        period_days: Optional[int] = None,
    ) -> Dict[str, Any]:
        """Compute period-filtered statistics from real recorded posts and visits."""
        filtered_posts = posts
        if period_days is not None and period_days > 0 and now_ticks > 0:
            cutoff = now_ticks - int(period_days) * TICKS_PER_SIM_DAY
            filtered_posts = [p for p in posts if int(p.get("created_tick", 0)) >= cutoff]

        total_likes = sum(len(p.get("likes", ())) for p in filtered_posts)
        total_comments = sum(len(p.get("comments", ())) for p in filtered_posts)
        total_shares = sum(len(p.get("reposts", ())) for p in filtered_posts)
        total_impressions = sum(int(p.get("impressions", 0)) for p in filtered_posts)
        reach_accounts = set()
        for p in filtered_posts:
            reach_accounts.update(p.get("reach", ()))
        total_reach = len(reach_accounts)
        eng_rate = self.calculate_engagement_rate(total_likes, total_comments, total_shares, total_reach)

        snaps = self.get_snapshots(sim_id, period_days)
        growth = 0
        if len(snaps) >= 2:
            growth = int(snaps[-1]["followers"]) - int(snaps[0]["followers"])

        top_posts = sorted(
            filtered_posts,
            key=lambda p: (len(p.get("likes", ())) + len(p.get("comments", ())) * 2 + len(p.get("reposts", ())) * 3),
            reverse=True,
        )[:5]

        return {
            "followers": int(followers_count),
            "following": int(following_count),
            "posts_count": len(filtered_posts),
            "likes": int(total_likes),
            "comments": int(total_comments),
            "shares": int(total_shares),
            "reach": int(total_reach),
            "impressions": int(total_impressions),
            "engagement_rate": eng_rate,
            "profile_visits": int(account.get("profile_visits", 0)),
            "growth": growth,
            "avg_engagement_per_post": round(
                float(total_likes + total_comments + total_shares) / max(1, len(filtered_posts)), 2
            ),
            "top_post_ids": [p["post_id"] for p in top_posts],
        }
