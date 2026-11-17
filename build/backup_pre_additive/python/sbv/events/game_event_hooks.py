# -*- coding: utf-8 -*-
"""Non-destructive runtime hooks for zone load, save persistence, and native Social Bunny events."""

from ..services.social_bunny_service import get_sbv_service

_HOOKS_INSTALLED = False


def install_game_hooks() -> None:
    """Attach safe wrappers to Zone load, PersistenceService save, and SocialMediaService events."""
    global _HOOKS_INSTALLED
    if _HOOKS_INSTALLED:
        return

    try:
        import zone

        orig_load = zone.Zone.on_loading_screen_animation_finished

        def _sbv_on_zone_loaded(self, *args, **kwargs):
            res = orig_load(self, *args, **kwargs)
            try:
                from ..ui_bridge.social_bunny_bridge import reset_world_seed_flag
                reset_world_seed_flag()
                sbv = get_sbv_service()
                sbv.reset_in_memory()
                sbv.ensure_loaded()
                # Sanitize deleted Sims safely
                try:
                    import services
                    mgr = services.sim_info_manager()
                    if mgr is not None:
                        sbv.persistence.sanitize_deleted_sims(
                            sbv.accounts,
                            sbv.followers,
                            sbv.posts,
                            sbv.notifications,
                            lambda sid: mgr.get(sid) is not None,
                        )
                except Exception:
                    pass
                sbv.npc_service.start_alarm()
            except Exception:
                pass
            return res

        zone.Zone.on_loading_screen_animation_finished = _sbv_on_zone_loaded
    except Exception:
        pass

    try:
        from services.persistence_service import PersistenceService as TS4PersistenceService

        orig_save = TS4PersistenceService.save_using

        def _sbv_on_save(self, *args, **kwargs):
            try:
                sbv = get_sbv_service()
                if sbv._loaded_slot_id is not None:
                    sbv.save()
            except Exception:
                pass
            return orig_save(self, *args, **kwargs)

        TS4PersistenceService.save_using = _sbv_on_save
    except Exception:
        pass

    try:
        from social_media.social_media_service import SocialMediaService as _SMService

        if hasattr(_SMService, "save"):
            _orig_sm_save = _SMService.save

            def _sbv_sm_save(self, *args, **kwargs):
                try:
                    sbv = get_sbv_service()
                    if sbv._loaded_slot_id is not None and sbv.persistence.is_dirty():
                        sbv.save()
                except Exception:
                    pass
                return _orig_sm_save(self, *args, **kwargs)

            _SMService.save = _sbv_sm_save
    except Exception:
        pass

    try:
        from social_media.social_media_service import SocialMediaService

        orig_create_post = SocialMediaService.create_post

        def _sbv_create_post(self, post_type, author_sim_id, target_sim_id, narrative, context_post=None):
            res = orig_create_post(self, post_type, author_sim_id, target_sim_id, narrative, context_post)
            try:
                sbv = get_sbv_service()
                sbv.ensure_loaded()
                acc = sbv.ensure_sim_account(author_sim_id)
                ptype_int = int(post_type)
                if ptype_int in (0, 4):
                    text, _ = sbv.posts.generate_contextual_content(
                        author_sim_id,
                        traits=acc.get("traits", []),
                        career=acc.get("career", ""),
                        post_type="text",
                    )
                    sbv.create_post(author_sim_id, text, post_type="text")
            except Exception:
                pass
            return res

        SocialMediaService.create_post = _sbv_create_post
    except Exception:
        pass

    _HOOKS_INSTALLED = True
