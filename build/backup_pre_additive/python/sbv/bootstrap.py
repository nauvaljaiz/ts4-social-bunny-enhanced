# -*- coding: utf-8 -*-
"""Bootstrap entry point executed when The Sims 4 loads SocialBunnyVerified.ts4script."""

from .events.game_event_hooks import install_game_hooks
from .ui_bridge.social_bunny_bridge import install_ui_bridge

_BOOTSTRAPPED = False


def initialize_mod() -> None:
    global _BOOTSTRAPPED
    if _BOOTSTRAPPED:
        return
    install_ui_bridge()
    install_game_hooks()
    _BOOTSTRAPPED = True


initialize_mod()
