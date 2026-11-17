# Compatibility Report — Social Bunny Verified

## Overridden Native Game Resources

**Social Bunny Verified** minimizes mod conflicts by overriding **only one** native resource:

| Resource | TGI Key | Package | Conflict Risk |
|---|---|---|---|
| `socialmedia` Scaleform GFX | `62ECC59A:00000000:8ABB350F01880C64` | `SocialBunnyVerified_UI.package` | Conflicts with any other mod that directly replaces `SocialMedia` (`0x8ABB350F01880C64`) GFX. |

## Non-Conflicting Systems

- **`widgetlist.xml` (`0333406C:00000000:DE3FB8F4E5C1A9E5`):** Not modified. Compatible with UI Cheats Extension, More Columns in CAS, MCCC, and HUD mods.
- **Native Pickers (`PickersColumnBasedMain` `0x3CC3EE76F45B2291`):** Not modified. Fully compatible with mods overriding picker GFX (such as `SimstagramMod`).
- **EP12 `social_media` XML Tuning:** Not wholesale-replaced. Native Social Bunny post types, narratives, buffs, and interactions remain intact; new buff/loot tuning (`0xB22C...`) uses unique custom instance IDs.
- **Third-Party Script Libraries:** Zero external dependencies (no XML Injector or community library required).
- **Namespace Isolation:** Python backend lives strictly under `sbv.*` inside `SocialBunnyVerified.ts4script` to avoid shadowing Sims 4's `services`, `interactions`, or `tuning` top-level modules.

## Post-Patch Maintenance

After major *The Sims 4* patches affecting `UI.package` (`0x8ABB350F01880C64`) or `simulation.zip` (`social_media/social_media_service.pyc`):
1. Re-run `python tools\audit_game_resources.py` to check if EA updated `SocialMedia` (`0x8ABB350F01880C64`) or `ShowSocialMediaPanel`.
2. Re-compile and validate with `python tools\build_packages.py`.
