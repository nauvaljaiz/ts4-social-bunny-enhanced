# -*- coding: utf-8 -*-
"""Four-segment audience tracking, niche drift, cancellation and redemption."""

import random


class AudienceEngine(object):
    def __init__(self, config=None, adapter=None):
        audience = (config or {}).get("audience", {})
        self.window = int(audience.get("niche_drift_window", 10))
        self.loyalist_loss = float(audience.get("niche_drift_loyalist_loss_pct", 0.12))
        self.bleed_min = float(audience.get("cancel_hourly_bleed_min_pct", 0.01))
        self.bleed_max = float(audience.get("cancel_hourly_bleed_max_pct", 0.03))
        self.charity_cost = int(audience.get("redemption_charity_cost", 1000))
        self.clean_hours = int(audience.get("redemption_clean_hours", 48))
        self.adapter = adapter

    def ensure_state(self, record):
        audience = record.setdefault("audience_segments", {
            "core_loyalists": 40,
            "casual_browsers": 35,
            "drama_vultures": 15,
            "anti_fans": 10,
        })
        for key in ("core_loyalists", "casual_browsers", "drama_vultures", "anti_fans"):
            audience.setdefault(key, 0)
        record.setdefault("post_categories", [])
        record.setdefault("cancelation_state", "NORMAL")
        record.setdefault("ratio_losses_24h", [])
        record.setdefault("redemption", {
            "clarification_post": False,
            "charity_donated": 0,
            "clean_hours": 0,
            "complete": False,
        })
        self.normalize(record)
        return record

    def normalize(self, record):
        audience = record.setdefault("audience_segments", {})
        keys = ("core_loyalists", "casual_browsers", "drama_vultures", "anti_fans")
        values = [max(0.0, float(audience.get(key, 0) or 0)) for key in keys]
        total = sum(values)
        if total <= 0:
            audience.update({"core_loyalists": 40.0, "casual_browsers": 35.0, "drama_vultures": 15.0, "anti_fans": 10.0})
            return audience
        normalized = [value * 100.0 / total for value in values]
        for key, value in zip(keys, normalized):
            audience[key] = round(value, 2)
        return audience

    def record_post(self, record, category):
        self.ensure_state(record)
        categories = list(record["post_categories"])
        categories.append(str(category))
        record["post_categories"] = categories[-self.window:]
        if str(category).lower() in ("mean", "brag"):
            wholesome = sum(1 for value in record["post_categories"][:-1] if str(value).lower() in ("friendly", "funny"))
            previous_count = max(1, len(record["post_categories"]) - 1)
            if previous_count > 0 and wholesome >= previous_count * 0.70:
                audience = record["audience_segments"]
                converted = round(float(audience["core_loyalists"]) * self.loyalist_loss, 2)
                audience["core_loyalists"] = max(0.0, audience["core_loyalists"] - converted)
                audience["anti_fans"] = audience["anti_fans"] + converted
                self.normalize(record)
        return record["audience_segments"]

    def set_state(self, record, state):
        valid = ("NORMAL", "CONTROVERSY_WATCH", "CANCEL_WAVE", "REDEMPTION", "SUSPENDED")
        if state not in valid:
            raise ValueError("Invalid cancellation state")
        record["cancelation_state"] = state
        if state == "REDEMPTION":
            record["redemption"]["complete"] = True
        return state

    def trigger(self, record, reason=None):
        self.ensure_state(record)
        state = str(record.get("cancelation_state", "NORMAL"))
        if state == "NORMAL":
            record["cancelation_state"] = "CONTROVERSY_WATCH"
        elif state == "CONTROVERSY_WATCH":
            record["cancelation_state"] = "CANCEL_WAVE"
        record["cancelation_trigger"] = reason
        return record["cancelation_state"]

    def apply_cancel_bleed(self, record, now=0, followers=None):
        self.ensure_state(record)
        if record["cancelation_state"] != "CANCEL_WAVE":
            return 0
        total = int(record.get("followers", followers or 0) or 0)
        pct = random.uniform(self.bleed_min, self.bleed_max)
        lost = int(round(total * pct))
        record["followers"] = max(0, total - lost)
        return lost

    def donate_charity(self, record, amount, charge_household=None):
        amount = max(0, int(amount))
        if amount < self.charity_cost:
            return {"ok": False, "code": "insufficient_donation", "message": "Minimum charity donation is \u00a7{}".format(self.charity_cost)}
        if charge_household:
            charge_household(amount)
        redemption = record.setdefault("redemption", {})
        redemption["charity_donated"] = int(redemption.get("charity_donated", 0) or 0) + amount
        record["charity_donated"] = int(record.get("charity_donated", 0) or 0) + amount
        return {"ok": True, "code": "donated", "amount": amount}

    def clarification_post(self, record):
        self.ensure_state(record)
        record["redemption"]["clarification_post"] = True
        return True

    def advance_redemption_clean_hours(self, record, hours):
        self.ensure_state(record)
        redemption = record["redemption"]
        redemption["clean_hours"] = int(redemption.get("clean_hours", 0) or 0) + int(hours)
        if (redemption["clarification_post"] and redemption["charity_donated"] >= self.charity_cost
                and redemption["clean_hours"] >= self.clean_hours):
            redemption["complete"] = True
            record["cancelation_state"] = "REDEMPTION"
            return True
        return False
