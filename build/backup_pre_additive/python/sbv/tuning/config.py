# -*- coding: utf-8 -*-
"""Configurable scoring and gameplay tuning defaults."""

from ..core.models import (
    DEFAULT_ENGAGEMENT_CONFIG,
    DEFAULT_VERIFICATION_CONFIG,
)


def apply_custom_verification_config(service, custom_weights=None, custom_thresholds=None, cooldown_hours=None):
    """Apply validated runtime verification scoring overrides."""
    if custom_weights:
        total = sum(float(v) for v in custom_weights.values())
        if total > 0:
            service.verification.config["weights"].update(custom_weights)
    if custom_thresholds:
        service.verification.config["thresholds"].update(custom_thresholds)
    if cooldown_hours is not None:
        service.verification.config["reapplication_cooldown_hours"] = max(1, int(cooldown_hours))


def apply_custom_engagement_config(service, like_weight=None, comment_weight=None, share_weight=None):
    """Apply validated engagement formula weights."""
    cfg = service.engagement.config
    if like_weight is not None:
        cfg["like_weight"] = float(like_weight)
    if comment_weight is not None:
        cfg["comment_weight"] = float(comment_weight)
    if share_weight is not None:
        cfg["share_weight"] = float(share_weight)


__all__ = [
    "DEFAULT_VERIFICATION_CONFIG",
    "DEFAULT_ENGAGEMENT_CONFIG",
    "apply_custom_verification_config",
    "apply_custom_engagement_config",
]
