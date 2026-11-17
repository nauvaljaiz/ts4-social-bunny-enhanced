# Changelog — Social Bunny Verified

## v1.0.0
- Reverse-engineered native `SocialMedia` Scaleform GFX (`62ECC59A:00000000:8ABB350F01880C64`) and `social_media` Python services/protobufs (`ShowSocialMediaDialog`, `SocialMediaFeedItem`, `CommunicationManager.PostServerCommand`).
- Built verified bidirectional UI bridge preserving native Social Bunny posts, contacts, and DMs while streaming chunked SBV JSON state packets (`post_type >= 100`).
- Implemented full Python 3.7 backend across `core/`, `services/`, `ui_bridge/`, `events/`, `interactions/`, and `tuning/` with save-slot JSON persistence and `.bak` recovery.
- Redesigned `SocialMedia.gfx` via JPEXS FFDec with 6-tab navigation (`Home`, `Explore`, `Alerts`, `Profile`, `Pro`, `Settings / DMs`), verified/official/creator/legacy badges, analytics bar charts, comment & report modals, verification portal, and brand collaboration inbox.
- Packaged `SocialBunnyVerified_UI.package`, `SocialBunnyVerified_Core.package`, and `SocialBunnyVerified.ts4script` in `dist/`.
