# -*- coding: utf-8 -*-
"""
Integration helpers preserving native Social Bunny phone/computer/tablet entry points.
"""

from ..services.social_bunny_service import get_sbv_service


def open_social_bunny_for_active_sim() -> bool:
    """Open native Social Bunny panel (enhanced by SBV GFX + UI bridge)."""
    try:
        import services
        si = services.active_sim_info()
        sm = services.get_social_media_service()
        if si is None or sm is None:
            return False
        sbv = get_sbv_service()
        sbv.ensure_sim_account(si.sim_id)
        sm.show_social_media_dialog(si.sim_id, is_update=False)
        return True
    except Exception:
        return False
