# -*- coding: utf-8 -*-
"""Analytics dashboard aggregation and time-series chart builder."""

from typing import Any, Dict, List


class AnalyticsService(object):
    """Builds dashboard cards, growth charts, and post comparisons from backend records."""

    PERIOD_MAP = {
        "7d": 7,
        "30d": 30,
        "90d": 90,
        "lifetime": None,
    }

    def __init__(self, engagement_manager: Any, post_manager: Any, follower_manager: Any) -> None:
        self._engagement = engagement_manager
        self._posts = post_manager
        self._followers = follower_manager

    def build_dashboard(
        self,
        sim_id: Any,
        account: Dict[str, Any],
        period_key: str = "30d",
        now_ticks: int = 0,
    ) -> Dict[str, Any]:
        days = self.PERIOD_MAP.get(period_key, 30)
        posts = self._posts.get_posts_by_author(sim_id)
        summary = self._engagement.summarize_account(
            sim_id=sim_id,
            account=account,
            posts=posts,
            followers_count=self._followers.get_follower_count(sim_id),
            following_count=self._followers.get_following_count(sim_id),
            now_ticks=now_ticks,
            period_days=days,
        )

        snapshots = self._engagement.get_snapshots(sim_id, period_days=days)
        if not snapshots:
            current_day = max(1, int(now_ticks // (24 * 60))) if now_ticks > 0 else 1
            snapshots = [
                {
                    "day": current_day,
                    "followers": summary["followers"],
                    "likes": summary["likes"],
                    "comments": summary["comments"],
                    "reach": summary["reach"],
                    "impressions": summary["impressions"],
                }
            ]

        followers_series = [int(s.get("followers", 0)) for s in snapshots]
        engagement_series = [int(s.get("likes", 0)) + int(s.get("comments", 0)) for s in snapshots]
        reach_series = [int(s.get("reach", 0)) for s in snapshots]
        impressions_series = [int(s.get("impressions", 0)) for s in snapshots]
        day_labels = ["D{}".format(s.get("day", idx + 1)) for idx, s in enumerate(snapshots)]

        top_posts_detail = []
        for p in sorted(posts, key=lambda x: float(x.get("engagement_score", 0.0)), reverse=True)[:5]:
            reach_n = len(p.get("reach", ()))
            likes_n = len(p.get("likes", ()))
            comments_n = len(p.get("comments", ()))
            reposts_n = len(p.get("reposts", ()))
            top_posts_detail.append({
                "post_id": p["post_id"],
                "snippet": p["content"][:54],
                "likes": likes_n,
                "comments": comments_n,
                "reposts": reposts_n,
                "reach": reach_n,
                "impressions": int(p.get("impressions", 0)),
                "eng_rate": self._engagement.calculate_engagement_rate(likes_n, comments_n, reposts_n, reach_n),
            })

        return {
            "period": period_key if period_key in self.PERIOD_MAP else "30d",
            "summary": summary,
            "charts": {
                "labels": day_labels[-12:],
                "followers": followers_series[-12:],
                "engagement": engagement_series[-12:],
                "reach": reach_series[-12:],
                "impressions": impressions_series[-12:],
            },
            "top_posts": top_posts_detail,
        }
