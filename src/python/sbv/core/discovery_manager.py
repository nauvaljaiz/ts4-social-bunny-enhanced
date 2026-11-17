# -*- coding: utf-8 -*-
"""Explore discovery, account recommendations, trending posts, and hashtags."""

from typing import Any, Callable, Dict, List, Optional, Set

from .models import AccountStatus, VerificationTier


class DiscoveryManager(object):
    """Scores and ranks recommended accounts, trending posts, and hashtags."""

    def __init__(self) -> None:
        self._last_suggested_cache: Dict[str, List[str]] = {}

    def recommend_accounts(
        self,
        viewer_sim_id: Any,
        all_accounts: List[Dict[str, Any]],
        follower_manager: Any,
        post_manager: Any,
        relationship_score_fn: Optional[Callable[[str, str], float]] = None,
        limit: int = 12,
        rotate_offset: int = 0,
    ) -> List[Dict[str, Any]]:
        """Score accounts based on traits, career, mutuals, engagement, and familiarity."""
        v_key = str(viewer_sim_id)
        viewer = next((a for a in all_accounts if str(a["sim_id"]) == v_key), None)
        viewer_traits = set(t.lower() for t in (viewer.get("traits", []) if viewer else []))
        viewer_career = (viewer.get("career", "") if viewer else "").lower()
        following_set = set(follower_manager.get_following(v_key))
        prev_ids = set(self._last_suggested_cache.get(v_key, ()))

        scored = []
        for acc in all_accounts:
            t_key = str(acc["sim_id"])
            if t_key == v_key or t_key in following_set:
                continue
            if acc.get("status") == AccountStatus.SUSPENDED:
                continue
            if follower_manager.is_blocked(v_key, t_key) or follower_manager.is_blocked(t_key, v_key):
                continue

            score = 0.0
            mutuals = len(follower_manager.get_mutual_followers(v_key, t_key))
            score += mutuals * 12.0

            t_traits = set(t.lower() for t in acc.get("traits", []))
            shared_traits = len(viewer_traits & t_traits)
            score += shared_traits * 8.0

            if viewer_career and acc.get("career", "").lower() == viewer_career:
                score += 10.0

            if relationship_score_fn is not None:
                try:
                    score += max(0.0, float(relationship_score_fn(v_key, t_key)) * 0.25)
                except Exception:
                    pass

            followers_cnt = follower_manager.get_follower_count(t_key)
            score += min(25.0, followers_cnt * 1.2)

            if acc.get("verification_tier", VerificationTier.NONE) != VerificationTier.NONE and not acc.get("badge_suspended"):
                score += 14.0

            posts = post_manager.get_posts_by_author(t_key)
            score += min(15.0, sum(float(p.get("engagement_score", 0.0)) for p in posts[:5]) * 0.4)

            # Slight diversity penalty for accounts shown right before refresh
            if t_key in prev_ids:
                score -= 6.0

            scored.append((score, acc))

        scored.sort(key=lambda item: item[0], reverse=True)
        if rotate_offset > 0 and len(scored) > limit:
            shift = rotate_offset % len(scored)
            scored = scored[shift:] + scored[:shift]

        selected = [item[1] for item in scored[:limit]]
        self._last_suggested_cache[v_key] = [str(a["sim_id"]) for a in selected]
        return selected

    def get_trending_posts(
        self,
        viewer_sim_id: Any,
        posts: List[Dict[str, Any]],
        follower_manager: Any,
        account_manager: Any,
        profile_manager: Any,
        limit: int = 15,
    ) -> List[Dict[str, Any]]:
        v_key = str(viewer_sim_id)
        visible = []
        for p in posts:
            author_id = p["author_sim_id"]
            if follower_manager.is_muted(v_key, author_id) or follower_manager.is_blocked(v_key, author_id):
                continue
            if not profile_manager.can_view_private_content(author_id, v_key, follower_manager):
                continue
            acc = account_manager.get_account(author_id)
            if acc and acc.get("status") == AccountStatus.SUSPENDED:
                continue
            visible.append(p)

        visible.sort(
            key=lambda p: (
                float(p.get("engagement_score", 0.0))
                + int(p.get("impressions", 0)) * 0.15
                + int(p.get("controversy_level", 0)) * 8.0
            ),
            reverse=True,
        )
        return visible[:limit]

    def get_trending_hashtags(self, posts: List[Dict[str, Any]], limit: int = 8) -> List[Dict[str, Any]]:
        counts: Dict[str, int] = {}
        for p in posts:
            if p.get("removed_by_mod"):
                continue
            weight = 1 + len(p.get("likes", ())) + len(p.get("comments", ()))
            for tag in p.get("hashtags", ()):
                t = str(tag).lower()
                counts[t] = counts.get(t, 0) + weight
        ranked = sorted(counts.items(), key=lambda x: x[1], reverse=True)[:limit]
        return [{"tag": "#{}".format(k), "score": v} for k, v in ranked]
