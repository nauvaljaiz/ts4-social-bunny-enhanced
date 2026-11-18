# -*- coding: utf-8 -*-
"""Credibility, Brand Safety, and dynamic RPM creator monetization."""


class CredibilityEngine(object):
    def __init__(self, config=None, adapter=None):
        credibility = (config or {}).get("credibility", {})
        dm = (config or {}).get("dm_balance", {})
        self.initial_credibility = int(credibility.get("initial_credibility", 65))
        self.initial_brand_safety = int(credibility.get("initial_brand_safety", 80))
        self.revocation_threshold = int(credibility.get("revocation_threshold", 25))
        self.inactivity_days = int(credibility.get("inactivity_decay_days", 4))
        self.spam_window_hours = int(credibility.get("spam_post_window_hours", 6))
        self.max_posts_per_window = int(credibility.get("max_posts_per_window", 2))
        self.base_rpm = float(credibility.get("base_rpm", 2.5))
        self.daily_payout_cap = max(0, int(credibility.get("daily_payout_cap", 250)))
        self.adapter = adapter

    def ensure_state(self, record):
        record.setdefault("credibility_score", self.initial_credibility)
        record.setdefault("brand_safety_score", self.initial_brand_safety)
        record.setdefault("last_post_at", 0)
        record.setdefault("post_times_6h", [])
        record.setdefault("censorship_heat_24h", [])
        record.setdefault("reativity_cooldown_until", 0)
        record.setdefault("reapplication_cooldown_until", 0)
        record.setdefault("active_strikes", 0)
        record.setdefault("suspension_reason", "")
        return record

    def get_suspension_reason(self, record, now):
        reason = str(record.get("suspension_reason", "") or "")
        if reason in ("payment", "credibility", "inactivity"):
            return reason
        if str(record.get("status", "")).lower() != "suspended":
            return ""

        if int(record.get("credibility_score", self.initial_credibility)) < self.revocation_threshold:
            return "credibility"

        last_post = int(record.get("last_post_at", 0) or 0)
        if last_post > 0 and self.adapter is not None:
            if int(now) - last_post >= self.adapter.ticks_from_days(self.inactivity_days):
                return "inactivity"
        if int(record.get("last_failure_at", 0) or 0) > int(
            record.get("last_successful_payment", 0) or 0
        ):
            return "payment"
        if int(record.get("current_period_end", 0) or 0) <= int(now):
            return "payment"
        return "payment"

    def clamp(self, value):
        return max(0, min(100, int(value)))

    def adjust(self, record, credibility_delta=0, brand_safety_delta=0):
        self.ensure_state(record)
        record["credibility_score"] = self.clamp(int(record["credibility_score"]) + int(credibility_delta))
        record["brand_safety_score"] = self.clamp(int(record["brand_safety_score"]) + int(brand_safety_delta))
        return record

    def constructive_reply(self, record):
        return self.adjust(record, 2, 1)

    def steady_post_cadence(self, record):
        return self.adjust(record, 2, 1)

    def dm_spam(self, record):
        return self.adjust(record, -3, 0)

    def lost_ratio(self, record):
        return self.adjust(record, -10, -2)

    def clap_back(self, record, win=False):
        return self.adjust(record, 0, -15 if win else -25)

    def excessive_delete(self, record):
        return self.adjust(record, -15, -5)

    def record_post(self, record, now, category="Friendly"):
        self.ensure_state(record)
        record["last_post_at"] = int(now)
        posts = list(record.get("post_times_6h", []))
        cutoff = self.adapter.ticks_from_hours(self.spam_window_hours) if self.adapter is not None else self.spam_window_hours * 1500
        posts = [tick for tick in posts if now - int(tick) <= cutoff]
        posts.append(int(now))
        record["post_times_6h"] = posts
        if len(posts) > self.max_posts_per_window:
            self.adjust(record, -8, -10)
        elif len(posts) <= 2:
            self.adjust(record, 2, 1)
        return len(posts)

    def calculate_dynamic_rpm(self, record, positive_reactions, negative_reactions):
        positive = max(0, int(positive_reactions))
        negative = max(0, int(negative_reactions))
        brand_safety = int(record.get("brand_safety_score", self.initial_brand_safety) or self.initial_brand_safety)
        payout = max(0, (positive - 2 * negative) * self.base_rpm * (brand_safety / 100.0))
        return int(round(payout))

    def check_suspension(self, record, now):
        self.ensure_state(record)
        status = str(record.get("status", "")).lower()
        if status not in ("active", "cancelled", "payment_failed", "grace_period") or status == "suspended":
            return False
        credibility = int(record["credibility_score"])
        last_post = int(record.get("last_post_at", 0) or 0)
        inactive = False
        if last_post > 0 and self.adapter is not None:
            inactive = now - last_post >= self.adapter.ticks_from_days(self.inactivity_days)
        if credibility < self.revocation_threshold or inactive:
            record["status"] = "suspended"
            record["suspension_reason"] = (
                "credibility" if credibility < self.revocation_threshold else "inactivity"
            )
            record["active_strikes"] = int(record.get("active_strikes", 0) or 0) + 1
            if self.adapter is not None:
                record["reapplication_cooldown_until"] = now + self.adapter.ticks_from_hours(72)
                record["cooldown_fee_multiplier"] = 1.5
            return True
        return False

    def try_reinstate(self, record, now):
        if str(record.get("status", "")).lower() != "suspended":
            return False
        reason = self.get_suspension_reason(record, now)
        if reason not in ("credibility", "inactivity"):
            return False
        if int(record.get("credibility_score", 0) or 0) < self.revocation_threshold:
            return False
        if int(now) < int(record.get("reapplication_cooldown_until", 0) or 0):
            return False

        last_post = int(record.get("last_post_at", 0) or 0)
        if last_post <= 0 or (
            self.adapter is not None
            and int(now) - last_post >= self.adapter.ticks_from_days(self.inactivity_days)
        ):
            return False

        period_end = int(record.get("current_period_end", 0) or 0)
        if period_end > 0 and int(now) >= period_end and not record.get("auto_renew", False):
            record["status"] = "expired"
            record["expiration_timestamp"] = int(now)
        else:
            record["status"] = "active"
            if period_end > 0 and int(now) >= period_end:
                record["next_billing_at"] = int(now)
        record["suspension_reason"] = ""
        record["reapplication_cooldown_until"] = 0
        return True
