# -*- coding: utf-8 -*-
"""Social Bunny Verified bootstrap for The Sims 4 script loader."""

from .verified.verified_account_service import VerifiedAccountService
from .verified.verified_billing_service import VerifiedBillingService
from .verified.verified_config import load_verified_config
from .verified.verified_eligibility_service import VerifiedEligibilityService
from .verified.verified_game_adapter import VerifiedGameAdapter
from .verified.verified_game_hooks import install_verified_game_hooks
from .verified.verified_notification_service import VerifiedNotificationService
from .verified.verified_persistence import VerifiedPersistence
from .verified.verified_subscription_manager import VerifiedSubscriptionManager
from .verified.verified_ui_bridge import VerifiedUIBridge

_BOOTSTRAPPED = False
_MANAGER = None
_BRIDGE = None


def get_verified_manager():
    global _MANAGER
    if _MANAGER is not None:
        return _MANAGER

    persistence = VerifiedPersistence()
    config = load_verified_config(persistence.data_dir)
    adapter = VerifiedGameAdapter()
    accounts = VerifiedAccountService(adapter, persistence)
    notifications = VerifiedNotificationService(adapter, persistence)
    billing = VerifiedBillingService(adapter, notifications, config["plan"])
    eligibility = VerifiedEligibilityService(adapter)
    _MANAGER = VerifiedSubscriptionManager(
        config=config,
        persistence=persistence,
        adapter=adapter,
        accounts=accounts,
        notifications=notifications,
        billing=billing,
        eligibility=eligibility,
    )
    return _MANAGER


def get_verified_bridge():
    global _BRIDGE
    if _BRIDGE is None:
        _BRIDGE = VerifiedUIBridge(get_verified_manager())
    return _BRIDGE


def initialize_mod():
    global _BOOTSTRAPPED
    if _BOOTSTRAPPED:
        return
    _BOOTSTRAPPED = True
    manager = get_verified_manager()
    bridge = get_verified_bridge()
    try:
        bridge.install()
    except Exception:
        bridge.log("bootstrap bridge failure")
    try:
        install_verified_game_hooks(manager)
    except Exception:
        bridge.log("bootstrap hooks failure")


try:
    initialize_mod()
except Exception:
    # Never prevent the game's script importer from continuing with other mods.
    pass
