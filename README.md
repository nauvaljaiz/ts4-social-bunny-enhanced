# Social Bunny Verified — Additive Native Verified Tab

**Social Bunny Verified** adds exactly one new tab to *The Sims 4* native Social Bunny application: **Verified**.

The original Feed, Friends, and Message tabs are preserved. The mod does not replace the Social Bunny interface, rebuild its panels, or introduce a separate social app. The new tab is compiled into a targeted override of the native `SocialMedia` Scaleform GFX and is backed by a persistent Python 3.7 subscription service.

## What the Verified tab does

- Shows a native-looking **Social Bunny Verified** subscription landing screen with a blue badge preview, §250 default price, per-Sim-week billing interval, eligibility, benefits, and current status.
- Supports **Not Subscribed**, **Eligible**, **Active**, **Payment Pending**, **Payment Failed**, **Grace Period**, **Cancelled**, **Expired**, and **Suspended** states.
- Requires explicit confirmation before any Simoleons are deducted.
- Renews automatically every 7 Sim days using in-game time and alarms.
- Handles failed renewals with a configurable grace period, retry payment, suspension, and preserved account data.
- Supports cancellation, retained benefits until the paid period ends, reactivation, and auto-renew toggles.
- Displays payment history and subscription activity.
- Applies real benefits: blue badge in the shared Social Bunny header, feed prioritization for verified authors, and priority in the native new-contact recommendation picker.

No real-world payment is ever used. The only currency is Simoleons.

## Deliverables

- `SocialBunnyVerified_UI.package` — one targeted resource override:
  - `SocialMedia` Scaleform GFX
  - Type `0x62ECC59A`, Group `0x00000000`, Instance `0x8ABB350F01880C64`
- `SocialBunnyVerified.ts4script` — Python 3.7 backend (`sbv.*` namespace)

The package does **not** override `widgetlist.xml`, shared UI libraries, textures, or native tuning.

## Why the original tabs stay vanilla

The implementation starts from the installed `SocialMedia` GFX and restores the original decompiled ActionScript for every native class. Only `SocialMediaPanel.as` is modified. The other 30 native ActionScript files remain byte-for-byte identical to the decompiled vanilla sources.

The Verified tab reuses:
- the native `FriendsTabTextButton` tab-button component,
- the native `SocialMediaFeedTabPanel` content-panel MovieClip as its backdrop,
- the native `PostButton_Tag` button skin,
- the native `$TextFont` / `$HeadlineFont` fonts.

## Build

```powershell
python tools\build_packages.py
# Build and copy the package + script archive to Documents\Electronic Arts\The Sims 4\Mods:
python tools\build_packages.py --deploy
```

## Tests

```powershell
& "C:\Users\nauval jaiz\Documents\the-sims-mods\simstagram\tools\python37\python.exe" tests\run_all_tests.py
```

The suite covers subscription charging, duplicate prevention, renewal success/failure, grace, suspension, cancellation, reactivation, persistence and migration, all status labels, state-packet encoding, feed/contact priority, and artifact validation.

## Configuration

The plan is configurable without editing Python. Create:

`Documents\Electronic Arts\The Sims 4\Mods\SocialBunnyVerified_Data\verified_config.json`

Example:

```json
{
  "plan": {
    "price": 250,
    "billing_interval_days": 7,
    "grace_period_days": 2,
    "retry_interval_hours": 12,
    "renewal_reminder_hours": 24
  }
}
```

The price and interval are read from this file; default values exist only in `verified_config.py`.

## Project layout

- `src/gfx/original/` — untouched original GFX backup
- `src/gfx/decompiled/` — FFDec reference decompilation
- `src/gfx/scripts/` — editable ActionScript (only `SocialMediaPanel.as` differs from vanilla)
- `src/gfx/compiled/` — compiled replacement GFX
- `src/python/sbv/verified/` — subscription, billing, eligibility, notifications, persistence, UI bridge, and hooks
- `tools/` — DBPF writer, asset encoder, game audit, and reproducible builder
- `tests/` — Python 3.7 test suite
- `docs/` — architecture, resource inventory, override plan, limitations, and test report
- `dist/` — installable UI package and `.ts4script`
