# -*- coding: utf-8 -*-
"""Configuration for the Social Bunny Verified subscription.

The plan price and billing interval are intentionally defined in one place.
Installations may override any value by placing ``verified_config.json`` in
``Documents/Electronic Arts/The Sims 4/Mods/SocialBunnyVerified_Data``.
"""

import json
import os

DEFAULT_CONFIG = {
    "schema_version": 2,
    "config_version": 1,
    "plan": {
        "plan_id": "social_bunny_verified",
        "name": "Social Bunny Verified",
        "tagline": "Get recognized with an official verification badge and unlock exclusive account benefits.",
        "price": 250,
        "currency": "Simoleons",
        "billing_interval_days": 7,
        "grace_period_days": 2,
        "retry_interval_hours": 12,
        "renewal_reminder_hours": 24,
        "benefits": [
            {
                "title": "Blue verification badge",
                "description": "Official blue check appears beside your name across Social Bunny.",
            },
            {
                "title": "2.5x Algorithm growth",
                "description": "Get +75 spotlight followers, 2.5x daily growth, and lower decay.",
            },
            {
                "title": "Creator ad revenue",
                "description": "Earn Simoleons from posts and reactions; claim payouts anytime.",
            },
            {
                "title": "Viral post engagement",
                "description": "Posts gain feed priority, +12 reach, and automatic NPC reactions.",
            },
            {
                "title": "Boost Reach perk",
                "description": "Launch a 4h Creator Spotlight (24h cooldown) for steady reach & Fame.",
            },
            {
                "title": "Clout & networking",
                "description": "Priority contacts, stronger initial friendships, and Fame bonuses.",
            },
        ],
    },
    "benefits": {
        "feed_priority_limit": 25,
        "contact_priority_enabled": True,
        "welcome_follower_bonus": 75,
        "follower_growth_multiplier": 2.5,
        "min_daily_follower_gain": 20,
        "post_follower_bonus": 12,
        "post_payout_base": 35,
        "reaction_payout_bonus": 10,
        "reaction_follower_bonus": 3,
        "fame_per_post": 12,
        "boost_duration_hours": 4,
        "boost_cooldown_hours": 24,
        "boost_follower_min": 45,
        "boost_follower_max": 110,
        "boost_payout_base": 60,
        "friendship_bonus_on_add": 1.5,
    },
    "persistence": {
        "schema_version": 2,
    },
    "tiers": {
        "creator_blue": {"name": "Creator Blue", "price": 250, "billing_days": 7, "min_followers": 300, "min_charisma": 4, "min_posts": 5, "min_credibility": 50},
        "partner_gold": {"name": "Partner Gold", "price": 850, "billing_days": 7, "min_followers": 2500, "min_credibility": 75, "min_fame": 2},
        "mogul_obsidian": {"name": "Mogul Obsidian", "price": 2500, "billing_days": 7, "min_followers": 10000, "min_credibility": 85, "min_fame": 3},
    },
    "credibility": {
        "initial_credibility": 65,
        "initial_brand_safety": 80,
        "revocation_threshold": 25,
        "inactivity_decay_days": 4,
        "spam_post_window_hours": 6,
        "max_posts_per_window": 2,
        "base_rpm": 2.5,
        "daily_payout_cap": 250,
        "max_daily_follower_bonus": 50,
    },
    "dm_balance": {
        "social_battery_max": 100.0,
        "dm_battery_cost": 8.0,
        "stranger_dm_battery_cost": 15.0,
        "battery_regen_per_hour": 5.0,
        "cooldown_hours": 12,
        "first_dm_rel_gain": 2.0,
        "second_dm_rel_gain": 0.5,
        "spam_dm_rel_penalty": -5.0,
        "flirty_leak_chance": 0.65,
        "friendship_bonus_on_add": 1.5,
    },
    "audience": {
        "niche_drift_window": 10,
        "niche_drift_loyalist_loss_pct": 0.12,
        "cancel_hourly_bleed_min_pct": 0.01,
        "cancel_hourly_bleed_max_pct": 0.03,
        "redemption_charity_cost": 1000,
        "redemption_clean_hours": 48,
    },
    "comments": {
        "ratio_threshold": 1.5,
        "ratio_window_hours": 4,
        "rival_ratio_follower_transfer_pct": 0.03,
        "clap_back_engagement_multiplier": 3.0,
        "clap_back_brand_safety_penalty": 15,
        "delete_spam_threshold_24h": 2,
        "streisand_credibility_penalty": 15,
    },
}

_CONFIG_CACHE = {}


def _merge(base, override):
    if not isinstance(base, dict):
        return override
    if not isinstance(override, dict):
        return base
    out = dict(base)
    for key, value in override.items():
        if key in out and isinstance(out[key], dict) and isinstance(value, dict):
            out[key] = _merge(out[key], value)
        else:
            out[key] = value
    return out


def config_path(data_dir):
    return os.path.join(str(data_dir), "verified_config.json")


def load_verified_config(data_dir):
    """Load optional JSON overrides, merged over the safe defaults."""
    key = os.path.abspath(str(data_dir))
    cached = _CONFIG_CACHE.get(key)
    if cached is not None:
        return cached

    merged = {
        "config_version": DEFAULT_CONFIG["config_version"],
        "schema_version": DEFAULT_CONFIG["schema_version"],
        "plan": dict(DEFAULT_CONFIG["plan"]),
        "benefits": dict(DEFAULT_CONFIG["benefits"]),
        "persistence": dict(DEFAULT_CONFIG["persistence"]),
        "tiers": dict(DEFAULT_CONFIG["tiers"]),
        "credibility": dict(DEFAULT_CONFIG["credibility"]),
        "dm_balance": dict(DEFAULT_CONFIG["dm_balance"]),
        "audience": dict(DEFAULT_CONFIG["audience"]),
        "comments": dict(DEFAULT_CONFIG["comments"]),
    }
    path = config_path(data_dir)
    try:
        if os.path.isfile(path):
            with open(path, "r", encoding="utf-8") as handle:
                overrides = json.load(handle)
            if isinstance(overrides, dict):
                merged = _merge(merged, overrides)
    except Exception:
        # A malformed optional config must never prevent the mod from loading.
        pass

    plan = merged["plan"]
    try:
        plan["price"] = max(1, int(plan.get("price", 250)))
    except Exception:
        plan["price"] = 250
    try:
        plan["billing_interval_days"] = max(1, int(plan.get("billing_interval_days", 7)))
    except Exception:
        plan["billing_interval_days"] = 7
    try:
        plan["grace_period_days"] = max(0, int(plan.get("grace_period_days", 2)))
    except Exception:
        plan["grace_period_days"] = 2
    try:
        plan["retry_interval_hours"] = max(1, int(plan.get("retry_interval_hours", 12)))
    except Exception:
        plan["retry_interval_hours"] = 12
    try:
        plan["renewal_reminder_hours"] = max(1, int(plan.get("renewal_reminder_hours", 24)))
    except Exception:
        plan["renewal_reminder_hours"] = 24

    _CONFIG_CACHE[key] = merged
    return merged


def clear_config_cache():
    _CONFIG_CACHE.clear()
