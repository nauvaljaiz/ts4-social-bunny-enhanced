# -*- coding: utf-8 -*-
"""Non-destructive gameplay hooks used by the Verified subscription."""

import random

_INSTALLED = False


def install_verified_game_hooks(manager):
    global _INSTALLED
    if _INSTALLED:
        return
    _INSTALLED = True

    _install_zone_and_save_hooks(manager)
    _install_contact_priority_hook(manager)
    try:
        manager.start_billing_alarm()
    except Exception:
        pass


def _install_zone_and_save_hooks(manager):
    try:
        import zone

        original_zone_load = zone.Zone.on_loading_screen_animation_finished

        def _verified_zone_loaded(self, *args, **kwargs):
            result = original_zone_load(self, *args, **kwargs)
            try:
                manager.reload()
                manager.process_due_all()
                manager.start_billing_alarm()
            except Exception:
                pass
            return result

        zone.Zone.on_loading_screen_animation_finished = _verified_zone_loaded
    except Exception:
        pass

    try:
        from services.persistence_service import PersistenceService as GamePersistenceService

        original_save = GamePersistenceService.save_using

        def _verified_save_using(self, *args, **kwargs):
            try:
                manager.ensure_loaded()
                manager.save()
            except Exception:
                pass
            return original_save(self, *args, **kwargs)

        GamePersistenceService.save_using = _verified_save_using
    except Exception:
        pass

    try:
        from social_media.social_media_service import SocialMediaService

        if hasattr(SocialMediaService, "save"):
            original_sm_save = SocialMediaService.save

            def _verified_sm_save(self, *args, **kwargs):
                try:
                    manager.ensure_loaded()
                    if manager.persistence.is_dirty():
                        manager.save()
                except Exception:
                    pass
                return original_sm_save(self, *args, **kwargs)

            SocialMediaService.save = _verified_sm_save
    except Exception:
        pass


def _install_contact_priority_hook(manager):
    """Give active Verified subscribers priority in the native contact picker."""
    try:
        from social_media.social_media_service import SocialMediaService

        original_pick = SocialMediaService.get_possible_new_social_media_friend

        def _verified_pick(self, sim_info):
            try:
                manager.ensure_loaded()
                manager.process_due_all()
                verified = set(manager.get_verified_sim_ids())
                if verified:
                    from interactions.context import InteractionContext, InteractionSource
                    from interactions.priority import Priority
                    from social_media.social_media_tuning import SocialMediaTunables

                    context = InteractionContext(
                        sim_info,
                        InteractionSource.SCRIPT_WITH_USER_INTENT,
                        Priority.Low,
                    )
                    available = list(
                        SocialMediaTunables.NEW_FRIEND_PICKER_INTERACTION._get_valid_sim_choices_gen(
                            sim_info, context
                        )
                    )
                    priority_choices = []
                    viewer_id = getattr(sim_info, "sim_id", None)
                    for choice in available:
                        choice_sim = getattr(choice, "sim_info", None)
                        choice_id = getattr(choice_sim, "sim_id", None)
                        if choice_id is None or str(choice_id) == str(viewer_id):
                            continue
                        if str(choice_id) in verified:
                            priority_choices.append(choice)
                    if priority_choices:
                        return random.choice(priority_choices).sim_info
            except Exception:
                pass
            return original_pick(self, sim_info)

        SocialMediaService.get_possible_new_social_media_friend = _verified_pick
    except Exception:
        pass
