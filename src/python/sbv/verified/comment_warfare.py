# -*- coding: utf-8 -*-
"""NPC comment threads, Ratio wars, and skill-checked moderation."""

import random


class CommentWarfareEngine(object):
    def __init__(self, config=None, adapter=None):
        comments = (config or {}).get("comments", {})
        self.ratio_threshold = float(comments.get("ratio_threshold", 1.5))
        self.ratio_window_hours = int(comments.get("ratio_window_hours", 4))
        self.transfer_pct = float(comments.get("rival_ratio_follower_transfer_pct", 0.03))
        self.clap_multiplier = float(comments.get("clap_back_engagement_multiplier", 3.0))
        self.clap_penalty = int(comments.get("clap_back_brand_safety_penalty", 15))
        self.delete_threshold = int(comments.get("delete_spam_threshold_24h", 2))
        self.streisand_penalty = int(comments.get("streisand_credibility_penalty", 15))
        self.adapter = adapter

    def ensure_state(self, record):
        record.setdefault("comment_threads", [])
        record.setdefault("purge_times_24h", [])
        record.setdefault("ratio_losses_24h", [])
        record.setdefault("organic_reach_multiplier", 1.0)
        return record

    def ratio_index(self, rival_likes, post_likes, rival_verified=False):
        return float(rival_likes) * (1.35 if rival_verified else 1.0) / max(1.0, float(post_likes))

    def evaluate_ratio(self, record, rival_likes, post_likes, rival_verified=False, now=0):
        index = self.ratio_index(rival_likes, post_likes, rival_verified)
        if index >= self.ratio_threshold:
            followers = int(record.get("followers", 0) or 0)
            transfer = int(round(followers * self.transfer_pct))
            record["followers"] = max(0, followers - transfer)
            record["credibility_score"] = max(0, int(record.get("credibility_score", 65) or 65) - 10)
            record["organic_reach_multiplier"] = 0.60
            losses = list(record.setdefault("ratio_losses_24h", []))
            window = self.adapter.ticks_from_hours(24) if self.adapter is not None else 24 * 1500
            losses = [tick for tick in losses if now - int(tick) <= window]
            losses.append(int(now))
            record["ratio_losses_24h"] = losses
            record["cancelation_state"] = "CANCEL_WAVE" if len(losses) >= 2 else "CONTROVERSY_WATCH"
            return {"ratioed": True, "ratio_index": index, "followers_lost": transfer}
        return {"ratioed": False, "ratio_index": index, "followers_lost": 0}

    def generate_thread(self, record, npc_count=5, now=0):
        self.ensure_state(record)
        followers = int(record.get("followers", 0) or 0)
        count = max(3, min(5, int(npc_count)))
        thread = {
            "id": "thread_{}".format(int(now)),
            "tick": int(now),
            "comments": [],
            "ratio_index": 0.0,
            "status": "active",
        }
        for index in range(count):
            hostility = random.random() < min(0.75, 0.35 + followers / 100000.0)
            thread["comments"].append({
                "npc_id": "npc_{}".format(index + 1),
                "kind": "rival" if hostility else ("defender" if random.random() < 0.4 else "neutral"),
                "likes": random.randint(1, max(2, int(followers / 100))),
            })
        rival_likes = sum(c["likes"] for c in thread["comments"] if c["kind"] == "rival")
        post_likes = max(1, int(followers / 25))
        thread["ratio_index"] = self.ratio_index(rival_likes, post_likes)
        record["comment_threads"].append(thread)
        record["comment_threads"] = record["comment_threads"][-20:]
        return thread

    def can_deescalate(self, charisma=0, logic=0):
        return charisma >= 6 or logic >= 5

    def can_clap_back(self, mischief=0, traits=None):
        traits = set(str(t).lower() for t in (traits or []))
        return mischief >= 4 or bool(traits.intersection(("hot-headed", "hot_headed", "mean")))

    def can_spin(self, mischief=0, traits=None, career=None):
        traits = set(str(t).lower() for t in (traits or []))
        career = str(career or "").lower()
        return mischief >= 7 or "secret agent" in career or "criminal" in career or bool(traits.intersection(("secret agent", "secret_agent", "criminal")))

    def clap_back_check(self, record, sim_mischief=0, sim_charisma=0, mood_bonus=0, rival_charisma=0, rival_fame=0, roll=None):
        sim_roll = int(sim_mischief) + int(sim_charisma) + int(mood_bonus)
        rival_roll = int(rival_charisma) + int(rival_fame) * 2
        actual_roll = sim_roll if roll is None else int(roll)
        if actual_roll >= rival_roll:
            record["brand_safety_score"] = max(0, int(record.get("brand_safety_score", 80)) - self.clap_penalty)
            return {"ok": True, "win": True, "engagement_multiplier": self.clap_multiplier}
        record["brand_safety_score"] = max(0, int(record.get("brand_safety_score", 80)) - 25)
        record["cancelation_state"] = "CONTROVERSY_WATCH"
        return {"ok": True, "win": False, "brand_safety_penalty": 25}

    def spin_narrative(self, record, verified_npc_present=False):
        if verified_npc_present:
            record["cancelation_state"] = "CANCEL_WAVE"
            return {"ok": True, "exposed": True, "cancelation_state": "CANCEL_WAVE"}
        return {"ok": True, "exposed": False}

    def silent_purge(self, record, now=0):
        self.ensure_state(record)
        purges = list(record["purge_times_24h"])
        if self.adapter is not None:
            cutoff = now - self.adapter.ticks_from_hours(24)
        else:
            cutoff = now - 24 * 1500
        purges = [tick for tick in purges if int(tick) >= cutoff]
        purges.append(int(now))
        record["purge_times_24h"] = purges
        record["censorship_heat_24h"] = purges
        if len(purges) > self.delete_threshold:
            record["credibility_score"] = max(0, int(record.get("credibility_score", 65)) - self.streisand_penalty)
            record["audience_segments"] = record.setdefault("audience_segments", {})
            audience = record["audience_segments"]
            audience["anti_fans"] = float(audience.get("anti_fans", 10)) + 8
            record["streisand_effect"] = True
            return {"ok": True, "streisand": True, "purge_count": len(purges)}
        return {"ok": True, "streisand": False, "purge_count": len(purges)}
