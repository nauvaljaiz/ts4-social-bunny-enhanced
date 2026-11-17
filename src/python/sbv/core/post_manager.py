# -*- coding: utf-8 -*-
"""Persistent Social Bunny posts, comments, replies, reactions, and contextual generator."""

import random
import re
from typing import Any, Dict, List, Optional, Tuple

from .models import PostType

HASHTAG_RE = re.compile(r"#([A-Za-z0-9_]{2,28})")

# Contextual templates keyed by trait / mood / career / milestone
CONTEXTUAL_TEMPLATES = {
    "mood": {
        "happy": [
            "Sunlit vibes in {location} today. Sometimes everything just clicks! #GoodVibes",
            "Feeling unstoppable right now. Hope everyone's day is shining! #HappySim",
        ],
        "inspired": [
            "A sudden spark of inspiration just hit me—time to create something iconic! #Inspired",
            "Sketched out three new ideas before lunch. Creativity never sleeps. #CreatorLife",
        ],
        "flirty": [
            "Is it warm in {location}, or is someone just looking extra charming today? #FlirtyMood",
            "Dress up, step out, see who notices. #DateNightVibes",
        ],
        "energized": [
            "Crushed my morning routine and still have energy to spare! #FitnessGoals",
            "Zero brakes today—let's make every hour count! #HustleMode",
        ],
        "confident": [
            "Walked into the room like I own the skyline. Mindset matters. #Confident",
            "Big goals need bold energy. Watch this space. #MainCharacter",
        ],
        "sad": [
            "Quiet rain outside, quiet thoughts inside. Taking a breather today. #RealTalk",
            "Not every day has to be a highlight reel. Be kind to yourselves. #Mood",
        ],
        "angry": [
            "Some people really test your patience before noon. Logging off for a minute. #Vent",
            "Unbelievable drama today. Deep breaths, moving on. #NoDrama",
        ],
        "focused": [
            "Locked in. Headphones on, notifications off, progress up. #DeepWork",
            "Flow state achieved. Nothing beats finishing a tough project. #Focused",
        ],
    },
    "trait": {
        "creative": [
            "Turned a blank canvas into something I'm genuinely proud of today. #ArtDaily",
            "Color palettes, textures, and late-night ideas. #CreativeSoul",
        ],
        "ambitious": [
            "Another milestone checked off the career board. Next stop: the top. #CareerGoals",
            "Success doesn't wait around—neither do I. #Ambition",
        ],
        "foodie": [
            "Plating matters almost as much as flavor. Tonight's dish was 10/10! #SimFoodie",
            "Found a hidden gem menu item that deserves its own fan club. #Foodstagram",
        ],
        "music": [
            "New melody stuck in my head since 6 AM. Session tonight! #SimMusic",
            "Nothing resets the soul like a clean chord progression. #StudioLife",
        ],
        "outgoing": [
            "Best nights are the ones surrounded by great people and louder laughs! #Squad",
            "Met so many awesome Sims in {location} today! #SocialBunny",
        ],
        "genius": [
            "Solved a problem I've been chewing on all week. Pure satisfaction. #Eureka",
            "Always questioning, always learning. #Curiosity",
        ],
    },
    "career": [
        "Wrapping up a huge shift in {career}. Proud of the team today! #WorkLife",
        "Behind the scenes of {career}—it's busier than it looks! #DayInTheLife",
    ],
    "milestone": [
        "Major milestone unlocked! Grateful for everyone following this journey. #Milestone",
        "Looking back at day one vs today—keep going, it's worth it! #Growth",
    ],
    "achievement": [
        "Just hit a brand-new personal achievement! Hard work pays off. #Achievement",
        "Leveling up one skill at a time. Today felt monumental! #LevelUp",
    ],
    "life_event": [
        "Big life update! Excited for this next chapter to begin. #LifeUpdate",
        "Moments like today stay with you forever. #Blessed",
    ],
    "general": [
        "Checking in from {location}. What's everyone up to tonight? #SocialBunny",
        "Coffee in hand, feed refreshed. Happy scrolling! #DailyPost",
        "Little reminder to celebrate the small wins today. #SimLife",
        "Sunset over {location} never gets old. #Aesthetic",
    ],
    "controversial": [
        "Unpopular opinion: half the 'influencers' on Social Bunny wouldn't last a day offline. #HotTake",
        "Let's be honest—popularity metrics are totally rigged for the same five Sims. #TruthBomb",
    ],
}


class PostManager(object):
    """Stores and manages persistent posts, comments, replies, likes, reposts, and saves."""

    MAX_POSTS = 350

    def __init__(self) -> None:
        self._posts: Dict[str, Dict[str, Any]] = {}
        self._post_order: List[str] = []
        self._next_post_seq: int = 1
        self._next_comment_seq: int = 1
        self._recent_templates: Dict[str, List[str]] = {}

    def load_dict(self, data: Dict[str, Any]) -> None:
        self._posts = {}
        self._post_order = []
        if not isinstance(data, dict):
            return
        self._next_post_seq = int(data.get("next_post_seq", 1))
        self._next_comment_seq = int(data.get("next_comment_seq", 1))
        raw_posts = data.get("posts", [])
        if isinstance(raw_posts, list):
            for p in raw_posts:
                if not isinstance(p, dict) or not p.get("post_id"):
                    continue
                pid = str(p["post_id"])
                norm = dict(p)
                norm["post_id"] = pid
                norm["author_sim_id"] = str(p.get("author_sim_id", "0"))
                norm.setdefault("content", "")
                norm.setdefault("post_type", PostType.TEXT)
                norm.setdefault("created_tick", 0)
                norm.setdefault("game_event", "")
                norm.setdefault("mood_context", "")
                norm.setdefault("hashtags", [])
                norm["likes"] = [str(x) for x in p.get("likes", [])]
                norm["reposts"] = [str(x) for x in p.get("reposts", [])]
                norm["saves"] = [str(x) for x in p.get("saves", [])]
                norm["reach"] = [str(x) for x in p.get("reach", [])]
                norm.setdefault("impressions", len(norm["reach"]))
                norm.setdefault("comments", [])
                norm.setdefault("visibility", "public")
                norm.setdefault("engagement_score", 0.0)
                norm.setdefault("is_sponsored", False)
                norm.setdefault("brand_name", "")
                norm.setdefault("native_post_id", "")
                norm.setdefault("removed_by_mod", False)
                norm.setdefault("controversy_level", 0)
                self._posts[pid] = norm
                self._post_order.append(pid)

    def to_dict(self) -> Dict[str, Any]:
        return {
            "next_post_seq": self._next_post_seq,
            "next_comment_seq": self._next_comment_seq,
            "posts": [self._posts[pid] for pid in self._post_order if pid in self._posts],
        }

    def get_post(self, post_id: str) -> Optional[Dict[str, Any]]:
        return self._posts.get(str(post_id))

    def get_all_posts(self, include_removed: bool = False) -> List[Dict[str, Any]]:
        out = []
        for pid in reversed(self._post_order):
            p = self._posts.get(pid)
            if p is None:
                continue
            if not include_removed and p.get("removed_by_mod"):
                continue
            out.append(p)
        return out

    def get_posts_by_author(self, sim_id: Any, include_removed: bool = False) -> List[Dict[str, Any]]:
        key = str(sim_id)
        return [p for p in self.get_all_posts(include_removed=include_removed) if p["author_sim_id"] == key]

    def create_post(
        self,
        author_sim_id: Any,
        content: str,
        post_type: str = PostType.TEXT,
        now_ticks: int = 0,
        mood_context: str = "",
        game_event: str = "",
        visibility: str = "public",
        is_sponsored: bool = False,
        brand_name: str = "",
        native_post_id: str = "",
        controversy_level: int = 0,
    ) -> Dict[str, Any]:
        text = (content or "").strip()
        if not text:
            text = "Just posted on Social Bunny!"
        if len(text) > 280:
            text = text[:280]

        pid = "sbv_p_{}".format(self._next_post_seq)
        self._next_post_seq += 1
        ptype = post_type if post_type in PostType.ALL else PostType.TEXT
        hashtags = [m.lower() for m in HASHTAG_RE.findall(text)]

        post = {
            "post_id": pid,
            "author_sim_id": str(author_sim_id),
            "content": text,
            "post_type": ptype,
            "created_tick": int(now_ticks),
            "game_event": game_event or "",
            "mood_context": mood_context or "",
            "hashtags": hashtags,
            "likes": [],
            "comments": [],
            "reposts": [],
            "saves": [],
            "impressions": 1,
            "reach": [str(author_sim_id)],
            "visibility": visibility,
            "engagement_score": 0.0,
            "is_sponsored": bool(is_sponsored),
            "brand_name": brand_name or "",
            "native_post_id": str(native_post_id or ""),
            "removed_by_mod": False,
            "controversy_level": int(controversy_level),
        }
        self._posts[pid] = post
        self._post_order.append(pid)
        self._trim_old_posts()
        return post

    def _trim_old_posts(self) -> None:
        while len(self._post_order) > self.MAX_POSTS:
            oldest = self._post_order.pop(0)
            self._posts.pop(oldest, None)

    def toggle_like(self, post_id: str, sim_id: Any) -> Dict[str, Any]:
        post = self.get_post(post_id)
        if post is None or post.get("removed_by_mod"):
            return {"ok": False, "error": "Post not found."}
        s_key = str(sim_id)
        likes = post["likes"]
        if s_key in likes:
            likes.remove(s_key)
            liked = False
        else:
            likes.append(s_key)
            liked = True
            self.record_view(post_id, s_key)
        self._recompute_score(post)
        return {"ok": True, "liked": liked, "likes_count": len(likes), "post": post}

    def add_like(self, post_id: str, sim_id: Any) -> bool:
        """Idempotent like (never duplicates)."""
        post = self.get_post(post_id)
        if post is None or post.get("removed_by_mod"):
            return False
        s_key = str(sim_id)
        if s_key in post["likes"]:
            return False
        post["likes"].append(s_key)
        self.record_view(post_id, s_key)
        self._recompute_score(post)
        return True

    def add_comment(
        self,
        post_id: str,
        author_sim_id: Any,
        text: str,
        now_ticks: int = 0,
        parent_comment_id: str = "",
        polarity: str = "neutral",
    ) -> Dict[str, Any]:
        post = self.get_post(post_id)
        if post is None or post.get("removed_by_mod"):
            return {"ok": False, "error": "Post not found."}
        cleaned = (text or "").strip()
        if not cleaned:
            return {"ok": False, "error": "Comment cannot be empty."}
        if len(cleaned) > 200:
            cleaned = cleaned[:200]
        cid = "sbv_c_{}".format(self._next_comment_seq)
        self._next_comment_seq += 1
        comment = {
            "comment_id": cid,
            "author_sim_id": str(author_sim_id),
            "text": cleaned,
            "created_tick": int(now_ticks),
            "parent_comment_id": str(parent_comment_id or ""),
            "polarity": polarity,
        }
        post["comments"].append(comment)
        self.record_view(post_id, author_sim_id)
        self._recompute_score(post)
        return {"ok": True, "comment": comment, "post": post}

    def delete_comment(self, post_id: str, comment_id: str, actor_sim_id: Any, is_moderator: bool = False) -> bool:
        post = self.get_post(post_id)
        if post is None:
            return False
        actor_key = str(actor_sim_id)
        for idx, c in enumerate(post["comments"]):
            if c.get("comment_id") == comment_id:
                if is_moderator or c.get("author_sim_id") == actor_key or post["author_sim_id"] == actor_key:
                    post["comments"].pop(idx)
                    self._recompute_score(post)
                    return True
                return False
        return False

    def delete_post(self, post_id: str, actor_sim_id: Any, is_moderator: bool = False) -> bool:
        post = self.get_post(post_id)
        if post is None:
            return False
        if not is_moderator and post["author_sim_id"] != str(actor_sim_id):
            return False
        if is_moderator:
            post["removed_by_mod"] = True
        else:
            self._posts.pop(post_id, None)
            if post_id in self._post_order:
                self._post_order.remove(post_id)
        return True

    def toggle_repost(self, post_id: str, sim_id: Any) -> Dict[str, Any]:
        post = self.get_post(post_id)
        if post is None or post.get("removed_by_mod"):
            return {"ok": False, "error": "Post not found."}
        s_key = str(sim_id)
        if s_key in post["reposts"]:
            post["reposts"].remove(s_key)
            reposted = False
        else:
            post["reposts"].append(s_key)
            reposted = True
            self.record_view(post_id, s_key)
        self._recompute_score(post)
        return {"ok": True, "reposted": reposted, "reposts_count": len(post["reposts"]), "post": post}

    def toggle_save(self, post_id: str, sim_id: Any) -> Dict[str, Any]:
        post = self.get_post(post_id)
        if post is None or post.get("removed_by_mod"):
            return {"ok": False, "error": "Post not found."}
        s_key = str(sim_id)
        if s_key in post["saves"]:
            post["saves"].remove(s_key)
            saved = False
        else:
            post["saves"].append(s_key)
            saved = True
        return {"ok": True, "saved": saved, "saves_count": len(post["saves"])}

    def record_view(self, post_id: str, viewer_sim_id: Any) -> None:
        post = self.get_post(post_id)
        if post is None:
            return
        post["impressions"] = int(post.get("impressions", 0)) + 1
        v_key = str(viewer_sim_id)
        if v_key not in post["reach"]:
            post["reach"].append(v_key)

    def _recompute_score(self, post: Dict[str, Any]) -> None:
        likes = len(post.get("likes", ()))
        comments = len(post.get("comments", ()))
        reposts = len(post.get("reposts", ()))
        saves = len(post.get("saves", ()))
        post["engagement_score"] = round(likes * 1.0 + comments * 2.5 + reposts * 3.0 + saves * 1.5, 2)

    def generate_contextual_content(
        self,
        sim_id: Any,
        mood: str = "",
        traits: Optional[List[str]] = None,
        career: str = "",
        location: str = "Willow Creek",
        post_type: str = PostType.TEXT,
    ) -> Tuple[str, str]:
        """Select non-repetitive contextual post text and effective post type."""
        s_key = str(sim_id)
        pool: List[Tuple[str, str]] = []

        if post_type == PostType.CONTROVERSIAL:
            for txt in CONTEXTUAL_TEMPLATES["controversial"]:
                pool.append((txt, PostType.CONTROVERSIAL))
        elif post_type in (PostType.MILESTONE, PostType.ACHIEVEMENT, PostType.LIFE_EVENT):
            for txt in CONTEXTUAL_TEMPLATES.get(post_type, CONTEXTUAL_TEMPLATES["milestone"]):
                pool.append((txt, post_type))
        else:
            mood_key = (mood or "").strip().lower()
            if mood_key in CONTEXTUAL_TEMPLATES["mood"]:
                for txt in CONTEXTUAL_TEMPLATES["mood"][mood_key]:
                    pool.append((txt, PostType.MOOD))
            for tr in (traits or []):
                tr_low = tr.lower()
                for k, tmpls in CONTEXTUAL_TEMPLATES["trait"].items():
                    if k in tr_low:
                        for txt in tmpls:
                            pool.append((txt, post_type))
            if career:
                for txt in CONTEXTUAL_TEMPLATES["career"]:
                    pool.append((txt, post_type))
            if not pool:
                for txt in CONTEXTUAL_TEMPLATES["general"]:
                    pool.append((txt, post_type))

        recent = self._recent_templates.setdefault(s_key, [])
        fresh = [item for item in pool if item[0] not in recent]
        chosen_tmpl, chosen_type = random.choice(fresh if fresh else pool)
        recent.append(chosen_tmpl)
        if len(recent) > 6:
            recent.pop(0)

        rendered = chosen_tmpl.format(
            location=location or "San Myshuno",
            career=career or "the studio",
        )
        return rendered, chosen_type

    def purge_sim(self, sim_id: Any) -> None:
        key = str(sim_id)
        for pid in list(self._post_order):
            p = self._posts.get(pid)
            if p and p["author_sim_id"] == key:
                self._posts.pop(pid, None)
                self._post_order.remove(pid)
