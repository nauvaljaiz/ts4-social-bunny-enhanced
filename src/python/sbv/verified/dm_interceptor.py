# -*- coding: utf-8 -*-
"""Asymmetric DM balancing, social battery, fan mail, and leak events."""

import random


class DMInterceptorEngine(object):
    def __init__(self, config=None, adapter=None):
        dm = (config or {}).get("dm_balance", {})
        self.max_battery = float(dm.get("social_battery_max", 100.0))
        self.dm_cost = float(dm.get("dm_battery_cost", 8.0))
        self.stranger_cost = float(dm.get("stranger_dm_battery_cost", 15.0))
        self.regen = float(dm.get("battery_regen_per_hour", 5.0))
        self.cooldown_hours = int(dm.get("cooldown_hours", 12))
        self.first_gain = float(dm.get("first_dm_rel_gain", 2.0))
        self.second_gain = float(dm.get("second_dm_rel_gain", 0.5))
        self.spam_penalty = float(dm.get("spam_dm_rel_penalty", -5.0))
        self.flirty_leak_chance = float(dm.get("flirty_leak_chance", 0.65))
        self.friendship_bonus = float(dm.get("friendship_bonus_on_add", 1.5))
        self.adapter = adapter

    def ensure_state(self, record):
        record.setdefault("social_battery", self.max_battery)
        record.setdefault("dm_pair_history", {})
        record.setdefault("fan_mail_pending", 0)
        record.setdefault("leak_events", [])
        record.setdefault("controversy_watch", False)
        return record

    def regen_battery(self, record, hours=1):
        self.ensure_state(record)
        record["social_battery"] = min(self.max_battery, float(record["social_battery"]) + self.regen * float(hours))
        return record["social_battery"]

    def send_dm(self, record, sender_id, target_id, is_friend=True, now=0, random_value=None):
        self.ensure_state(record)
        cost = self.dm_cost if is_friend else self.stranger_cost
        battery = float(record["social_battery"])
        if battery < cost:
            return {"allowed": False, "reason": "social_battery", "battery": battery, "friendship_delta": 0.0}
        battery -= cost
        record["social_battery"] = max(0.0, battery)
        pair = "{}:{}".format(sender_id, target_id)
        history = record["dm_pair_history"].setdefault(pair, [])
        cutoff = now - self.cooldown_ticks()
        history[:] = [tick for tick in history if int(tick) >= cutoff]
        count = len(history)
        if count == 0:
            delta = self.first_gain
        elif count == 1:
            delta = self.second_gain
            roll = random.random() if random_value is None else random_value
            if roll < 0.5:
                delta = 0.0
                record["left_on_read"] = True
        else:
            delta = self.spam_penalty
            record["credibility_score"] = max(0, int(record.get("credibility_score", 65)) - 3)
        history.append(int(now))
        record["dm_pair_history"][pair] = history
        return {"allowed": True, "friendship_delta": delta, "battery": record["social_battery"], "dm_count": count + 1}

    def cooldown_ticks(self):
        return int(self.adapter.ticks_from_hours(self.cooldown_hours)) if self.adapter is not None else self.cooldown_hours * 1500

    def add_friend_bonus(self, target_traits=None):
        traits = set(str(t).lower() for t in (target_traits or []))
        if "loner" in traits or "proper" in traits:
            return 0.0
        return self.friendship_bonus

    def whisper_network(self, record, rel_a_b=0.0, rel_b_c=0.0, traits=None, random_value=None):
        if rel_b_c >= 50:
            return {"success": False, "leaked": True, "reason": "trusted_relation"}
        delta = rel_a_b - rel_b_c
        traits = set(str(t).lower() for t in (traits or []))
        bonus = 12 if "nosy" in traits else 0
        bonus += 8 if "mean" in traits else 0
        bonus += 5 if "snob" in traits else 0
        roll = random.random() if random_value is None else random_value
        success = roll <= max(0.05, min(0.95, (delta + bonus) / 100.0))
        return {"success": success, "leaked": False, "reason": "gossip_success" if success else "gossip_failed"}

    def flirty_dm(self, record, target_traits=None, mood=None, random_value=None):
        traits = set(str(t).lower() for t in (target_traits or []))
        mood = str(mood or "").lower()
        if "unflirty" not in traits and "loyal" not in traits and mood not in ("angry", "uncomfortable"):
            return {"leaked": False}
        roll = random.random() if random_value is None else random_value
        if roll < self.flirty_leak_chance:
            return self.apply_leak(record)
        return {"leaked": False}

    def apply_leak(self, record, percent=None, now=0):
        self.ensure_state(record)
        if percent is None:
            percent = random.uniform(0.10, 0.25)
        followers = int(record.get("followers", 0) or 0)
        lost = int(round(followers * percent))
        record["followers"] = max(0, followers - lost)
        event = {"type": "leak", "percent": float(percent), "followers_lost": lost, "tick": int(now)}
        record["leak_events"].append(event)
        record["controversy_watch"] = True
        record["cancelation_state"] = "CANCEL_WAVE"
        return {"leaked": True, "followers_lost": lost, "event": event}
