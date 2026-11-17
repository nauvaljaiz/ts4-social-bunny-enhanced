# Installation Guide — Social Bunny Verified

## Prerequisites

- **The Sims 4** (Windows/macOS) with **High School Years (EP12)** for the native Social Bunny phone app.
- **Script Mods Enabled** in *Game Options -> Other -> Enable Custom Content and Mods* AND *Script Mods Allowed*.

## Installation Steps

1. Copy all three files from `dist/` into your *The Sims 4* `Mods` folder (`Documents\Electronic Arts\The Sims 4\Mods\`):
   - `SocialBunnyVerified_UI.package`
   - `SocialBunnyVerified_Core.package`
   - `SocialBunnyVerified.ts4script`
   *(Do **not** place `.ts4script` deeper than 1 subfolder inside `Mods/`.)*
2. Clear `localthumbcache.package` in `Documents\Electronic Arts\The Sims 4\` if upgrading or replacing an older UI mod.
3. Launch *The Sims 4*, load a household, click the Sim's **Phone** -> **Social** -> **Open Social Bunny** (or use a computer/tablet).

## Console Debug Commands (Optional)

With the cheat console (`Ctrl+Shift+C`), you can inspect or test backend state:
- `sbv.status` — prints registered accounts and posts count.
- `sbv.npc_tick` — triggers one batched NPC simulation step immediately.
- `sbv.verify_active` — grants Blue Verified status to the active Sim for testing.

## Uninstallation

Remove the three `SocialBunnyVerified*` files (and optional `Mods\SocialBunnyVerified_Data\` folder) from your `Mods` directory. Original game files are never modified.
