# -*- coding: utf-8 -*-
"""Three-tier Verified hierarchy and time-bound brand contracts."""

import random


DEFAULT_TIERS = {
    "creator_blue": {"name": "Creator Blue", "price": 250, "billing_days": 7, "min_followers": 300, "min_charisma": 4, "min_posts": 5, "min_credibility": 50, "min_fame": 0},
    "partner_gold": {"name": "Partner Gold", "price": 850, "billing_days": 7, "min_followers": 2500, "min_credibility": 75, "min_fame": 2},
    "mogul_obsidian": {"name": "Mogul Obsidian", "price": 2500, "billing_days": 7, "min_followers": 10000, "min_credibility": 85, "min_fame": 3},
}


def merge_tier_config(config):
    tiers = dict(DEFAULT_TIERS)
    override = (config or {}).get("tiers", {})
    if isinstance(override, dict):
        for key, value in override.items():
            if isinstance(value, dict):
                merged = dict(tiers.get(key, {}))
                merged.update(value)
                tiers[key] = merged
    return tiers


class TiersAndContractsEngine(object):
    def __init__(self, config=None, adapter=None):
        self.config = config or {}
        self.adapter = adapter
        self.tiers = merge_tier_config(self.config)

    def ensure_state(self, record):
        record.setdefault("tier", "creator_blue")
        record.setdefault("contracts", [])
        record.setdefault("contract_lock_until", 0)
        record.setdefault("active_strikes", 0)
        record.setdefault("charity_donated", 0)
        return record

    def get_tier(self, record):
        return str(record.get("tier", "creator_blue"))

    def eligibility(self, record, followers=0, charisma=0, fame=0, public_posts=0, credibility=65):
        self.ensure_state(record)
        strikes = int(record.get("active_strikes", 0) or 0)
        gates = (
            ("mogul_obsidian", followers >= 10000 and credibility >= 85 and fame >= 3 and strikes == 0),
            ("partner_gold", followers >= 2500 and credibility >= 75 and fame >= 2 and strikes == 0),
            ("creator_blue", followers >= 300 and (charisma >= 4 or fame >= 1) and public_posts >= 5 and credibility >= 50),
        )
        for tier, eligible in gates:
            if eligible:
                return tier
        return "none"

    def calculate_tier_unlock(self, followers, charisma, fame, public_posts, credibility, active_strikes=0):
        dummy = {"active_strikes": active_strikes}
        return self.eligibility(dummy, followers, charisma, fame, public_posts, credibility)

    def upgrade(self, record, target_tier):
        self.ensure_state(record)
        if target_tier not in self.tiers:
            return {"ok": False, "code": "invalid_tier", "message": "Unknown tier."}
        record["tier"] = target_tier
        record["subscription_tier"] = target_tier
        return {"ok": True, "code": "tier_upgraded", "message": "Tier changed.", "tier": target_tier}

    def generate_contract(self, record, now, sponsor=None):
        self.ensure_state(record)
        if int(record.get("contract_lock_until", 0) or 0) > now:
            return None
        if record.get("contracts"):
            return record["contracts"][0]
        tier = self.get_tier(record)
        if tier not in ("partner_gold", "mogul_obsidian"):
            return None
        sponsors = ["Landgraab Telecom", "Goth Couture", "Britechester Tech", "SimNational Fitness"]
        contract = {
            "id": "sla_{}".format(int(now)),
            "sponsor": sponsor or random.choice(sponsors),
            "deadline": now + self.ticks_from_hours(48),
            "required_posts": 3,
            "positive_posts": 0,
            "min_brand_safety": 70,
            "payout": 1800 if tier == "partner_gold" else 5000,
            "clawback": 900 if tier == "partner_gold" else 2500,
            "status": "active",
        }
        record["contracts"] = [contract]
        return contract

    def ticks_from_hours(self, hours):
        if self.adapter is not None:
            return int(self.adapter.ticks_from_hours(hours))
        return int(hours) * 1500

    def record_positive_post(self, record, category="Friendly"):
        contracts = record.setdefault("contracts", [])
        if not contracts:
            return
        contract = contracts[0]
        if contract.get("status") == "active" and str(category).lower() in ("friendly", "funny", "hype", "positive"):
            contract["positive_posts"] = int(contract.get("positive_posts", 0) or 0) + 1

    def process_contracts(self, record, now, brand_safety, charge_household=None):
        self.ensure_state(record)
        contracts = record.setdefault("contracts", [])
        changed = False
        for contract in list(contracts):
            if contract.get("status") != "active":
                continue
            breached = int(contract.get("deadline", 0) or 0) <= now or brand_safety < int(contract.get("min_brand_safety", 70))
            completed = int(contract.get("positive_posts", 0) or 0) >= int(contract.get("required_posts", 3))
            if completed:
                contract["status"] = "completed"
                record["pending_payout"] = int(record.get("pending_payout", 0) or 0) + int(contract.get("payout", 0))
                record["credibility_score"] = min(100, int(record.get("credibility_score", 65) or 65) + 5)
                changed = True
            elif breached:
                contract["status"] = "breached"
                record["credibility_score"] = max(0, int(record.get("credibility_score", 65) or 65) - 25)
                record["active_strikes"] = int(record.get("active_strikes", 0) or 0) + 1
                record["contract_lock_until"] = now + self.ticks_from_hours(7 * 24)
                if charge_household:
                    charge_household(int(contract.get("clawback", 0)))
                changed = True
        record["contracts"] = [contract for contract in contracts if contract.get("status") == "active"]
        return changed
