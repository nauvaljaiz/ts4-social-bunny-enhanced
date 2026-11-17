# -*- coding: utf-8 -*-
"""Configuration for the Social Bunny Verified subscription.

The plan price and billing interval are intentionally defined in one place.
Installations may override any value by placing ``verified_config.json`` in
``Documents/Electronic Arts/The Sims 4/Mods/SocialBunnyVerified_Data``.
"""

import json
import os

DEFAULT_CONFIG = {
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
                "description": "An official blue check appears beside your Social Bunny name.",
            },
            {
                "title": "Verified account identity",
                "description": "Your account is visibly labeled as Social Bunny Verified.",
            },
            {
                "title": "Increased content visibility",
                "description": "Your posts receive priority placement in Social Bunny feeds.",
            },
            {
                "title": "Priority recommendations",
                "description": "Verified accounts are recommended first for new Social Bunny contacts.",
            },
            {
                "title": "Exclusive profile recognition",
                "description": "Verified presentation follows your account across the app.",
            },
            {
                "title": "Subscriber notifications",
                "description": "Renewals, payments, and account changes appear in your Verified activity.",
            },
        ],
    },
    "benefits": {
        "feed_priority_limit": 25,
        "contact_priority_enabled": True,
    },
    "persistence": {
        "schema_version": 2,
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
        "plan": dict(DEFAULT_CONFIG["plan"]),
        "benefits": dict(DEFAULT_CONFIG["benefits"]),
        "persistence": dict(DEFAULT_CONFIG["persistence"]),
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
