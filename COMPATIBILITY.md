# Compatibility Report — Social Bunny Verified

## Overridden Native Resource

| Resource | TGI Key | Package | Conflict Risk |
|---|---|---|---|
| `SocialMedia` Scaleform GFX | `0x62ECC59A:0x00000000:0x8ABB350F01880C64` | `SocialBunnyVerified_UI.package` | Conflicts only with another mod that directly replaces the same `SocialMedia` GFX. |

The resource override keeps the exact native Type, Group, and Instance identifiers discovered in the installed game files. No original game file is modified.

## Explicitly Not Overridden

- **`widgetlist.xml`** (`0333406C:00000000:DE3FB8F4E5C1A9E5`) — untouched. HUD, CAS, More Columns, MCCC, UI Cheats, and other widget-list mods remain compatible.
- **Shared libraries** — `ComponentLibrary`, `GUIComponentLibrary`, `HUDLibrary`, `gfxfontlib`, and `ClassLibraryGamedata` are imported at runtime and untouched.
- **`socialmedia_I1` texture** — untouched. The Verified badge is vector-drawn; no DDS atlas replacement is required.
- **Native Social Bunny tuning** — not replaced. Feed, Friends, Message, posts, DMs, relationships, and native pickers keep their original behavior.
- **Other phone applications** — untouched.

## Vanilla Preservation

- 30 of 31 ActionScript files in `src/gfx/scripts/` are byte-for-byte identical to the decompiled vanilla sources.
- Only `SocialMediaPanel.as` is modified, additively:
  - registers the fourth tab,
  - filters state packets out of the native feed,
  - hosts the Verified content inside a native `SocialMediaFeedTabPanel`,
  - updates the shared header badge.
- Existing navigation buttons keep their original component classes, skins, fonts, and relative ordering. The native three-tab group is recentered to make room for the fourth full-size tab; no existing tab is resized.
- Repeated navigation reuses the same tab-panel map entries and never creates duplicate panels.

## Script Isolation

- Python lives under the `sbv.*` namespace inside `SocialBunnyVerified.ts4script`.
- The subscription system is isolated in `sbv.verified.*`.
- Existing native commands (`social_media.*`, `interactions.push`) remain intact.
- The only new inbound command is `sbv.verified`.

## Post-Patch Maintenance

After a game patch that changes `SocialMedia`:

1. Re-run `python tools\audit_game_resources.py` and confirm the `0x8ABB350F01880C64` GFX and `ShowSocialMediaPanel` bridge are still current.
2. Re-run `python tools\build_packages.py`.
3. Re-run the Python 3.7 test suite.
4. Perform the in-game checklist in `docs/TEST_REPORT.md`.
