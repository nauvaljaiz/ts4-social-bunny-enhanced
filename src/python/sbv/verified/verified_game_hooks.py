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
    _install_verified_perk_hooks(manager)
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


def _install_verified_perk_hooks(manager):
    """Hook native Social Bunny posting, reactions, followers, and friends for active Verified perks."""
    try:
        from social_media import SocialMediaPostType
        from social_media.social_media_service import SocialMediaService
    except Exception:
        return

    reentry = {"active": False}

    if hasattr(SocialMediaService, "create_post"):
        original_create_post = SocialMediaService.create_post

        def _verified_create_post(self, post_type, author_sim_id, target_sim_id, narrative, context_post=None):
            result = original_create_post(self, post_type, author_sim_id, target_sim_id, narrative, context_post)
            if reentry["active"]:
                return result
            try:
                if post_type in (SocialMediaPostType.DEFAULT, SocialMediaPostType.PUBLIC_POST):
                    manager.ensure_loaded()
                    if manager.is_verified(author_sim_id):
                        reentry["active"] = True
                        try:
                            manager.on_verified_post_created(author_sim_id)
                            manager.adapter.simulate_npc_reactions(author_sim_id, 2)
                        finally:
                            reentry["active"] = False
            except Exception:
                pass
            return result

        SocialMediaService.create_post = _verified_create_post

    if hasattr(SocialMediaService, "add_reaction_to_post"):
        original_add_reaction = SocialMediaService.add_reaction_to_post

        def _verified_add_reaction(self, author_sim_id, target_sim_id, reacted_post, new_reaction):
            had_reacted = False
            try:
                had_reacted = bool(reacted_post is not None and reacted_post.sim_has_reacted(author_sim_id))
            except Exception:
                had_reacted = False
            result = original_add_reaction(self, author_sim_id, target_sim_id, reacted_post, new_reaction)
            try:
                if not had_reacted and reacted_post is not None:
                    post_owner = getattr(reacted_post, "author_sim_id", target_sim_id)
                    if post_owner is not None and str(author_sim_id) != str(post_owner):
                        manager.ensure_loaded()
                        if manager.is_verified(post_owner):
                            manager.on_verified_post_reaction(post_owner)
            except Exception:
                pass
            return result

        SocialMediaService.add_reaction_to_post = _verified_add_reaction

    if hasattr(SocialMediaService, "calculate_social_media_followers"):
        original_calc_followers = SocialMediaService.calculate_social_media_followers

        def _verified_calc_followers(self, author_sim_id):
            before = 0
            try:
                before = int(self.get_current_followers_count(author_sim_id) or 0)
            except Exception:
                before = 0
            result = original_calc_followers(self, author_sim_id)
            try:
                manager.ensure_loaded()
                if manager.is_verified(author_sim_id):
                    after = int(self.get_current_followers_count(author_sim_id) or 0)
                    manager.on_verified_follower_recount(author_sim_id, after - before)
            except Exception:
                pass
            return result

        SocialMediaService.calculate_social_media_followers = _verified_calc_followers

    if hasattr(SocialMediaService, "add_social_media_friend"):
        original_add_friend = SocialMediaService.add_social_media_friend

        def _verified_add_friend(self, author_sim_id, target_sim_id):
            result = original_add_friend(self, author_sim_id, target_sim_id)
            try:
                manager.ensure_loaded()
                if manager.is_verified(author_sim_id):
                    manager.on_verified_friend_added(author_sim_id, target_sim_id)
            except Exception:
                pass
            return result

        SocialMediaService.add_social_media_friend = _verified_add_friend
