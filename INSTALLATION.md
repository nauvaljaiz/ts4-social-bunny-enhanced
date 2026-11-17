# Installation Guide — Social Bunny Verified

## Prerequisites

- **The Sims 4** with **High School Years (EP12)** for the native Social Bunny phone app.
- Script mods enabled:
  - *Game Options → Other → Enable Custom Content and Mods*
  - *Script Mods Allowed*

## Install

1. Copy both files from `dist/` into your Mods folder:
   - `SocialBunnyVerified_UI.package`
   - `SocialBunnyVerified.ts4script`
   - Default location: `Documents\Electronic Arts\The Sims 4\Mods\`
2. Do not place the `.ts4script` more than one subfolder deep inside `Mods/`.
3. Delete `localthumbcache.package` from `Documents\Electronic Arts\The Sims 4\` if you are upgrading from the previous 6-tab build.
4. Launch the game, load a household, and open the Sim's phone → **Social** → **Open Social Bunny**.

The original Feed, Friends, and Message tabs work exactly as before. A fourth **Verified** tab appears after Message.

## Using Verified

1. Open the Verified tab.
2. Review the plan, price, interval, eligibility, and benefits.
3. Click **Subscribe**.
4. Confirm the explicit Simoleon charge. No money is deducted before you click **Confirm**.
5. Manage the subscription from the same tab: auto-renew, cancel, reactivate, retry payment, payment history, and activity.

The default plan is **§250 per Sim week**. It can be changed without editing code by creating:

`Documents\Electronic Arts\The Sims 4\Mods\SocialBunnyVerified_Data\verified_config.json`

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

## Console Commands (Optional)

- `sbv.verified_status` — prints the loaded save slot, subscription count, and verified count.
- `sbv.verified_tick` — runs one billing check immediately.
- `sbv.verified_reload` — reloads the subscription data for the current save slot.

## Uninstall

Remove `SocialBunnyVerified_UI.package` and `SocialBunnyVerified.ts4script`. Subscription JSON data is stored separately in `Mods\SocialBunnyVerified_Data\` and can be removed or kept.
