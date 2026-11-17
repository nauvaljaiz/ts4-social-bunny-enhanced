# Gameplay Architecture — Verified Subscription

All subscription gameplay lives under `src/python/sbv/verified/` and targets the game's Python 3.7 runtime.

## Modules

### `verified_subscription_manager.py`
Orchestrates the complete lifecycle:

- create, subscribe, activate, cancel, reactivate, suspend, expire
- duplicate-purchase prevention
- auto-renew toggles
- retry payment
- UI snapshot construction
- feed and contact priority
- hourly billing tick

### `verified_billing_service.py`
- Simoleon-only charges through the household funds API.
- Full-amount `try_remove`; partial or failed deductions never activate a subscription.
- Current billing period, next billing tick, last successful payment, payment amount.
- Payment history with success/failure entries.
- Renewal reminders, payment failure, grace period, suspension, expiration.

### `verified_account_service.py`
- Stable `sba_<sim_id>` account ID.
- Stable Sim ID key.
- Deterministic `@username`.
- Display name resolution from the Sim.

### `verified_eligibility_service.py`
- Player-controlled Sim check.
- Household availability.
- Existing subscription state checks.
- Funds check before presenting an enabled Subscribe action.

### `verified_notification_service.py`
- Bounded per-Sim activity inbox.
- Subscription activations, renewals, reminders, failures, grace, cancellation, expiration, suspension, retries.
- Last-action result used by the UI banner.

### `verified_persistence.py`
- Per-save-slot JSON file:
  `Mods/SocialBunnyVerified_Data/verified_subscriptions_slot_<slot>.json`
- Schema version 2 with migration from older list/dict payloads.
- Atomic replacement and `.bak` recovery.
- No permanent deletion on expiration; records and payment history remain.

### `verified_game_adapter.py`
Defensive wrappers around the real APIs:

- `services.time_service().sim_now.absolute_ticks()`
- `date_and_time.sim_ticks_per_day()`
- `services.get_persistence_service().get_save_slot_proto_buff().slot_id`
- `services.sim_info_manager().get(sim_id)`
- `household.funds.can_afford()` / `try_remove()`

### `verified_ui_bridge.py`
- Wraps `SocialMediaService.show_social_media_dialog`.
- Preserves native feed items, messages, follower count, and badges flags.
- Appends chunked JSON state packets using valid `post_type = 0` and a reserved `post_id` range (`9000000+`).
- Registers `sbv.verified` and debug commands.
- Pushes an immediate state refresh after every action.

### `verified_game_hooks.py`
- Reloads subscription data on zone load / household switch.
- Saves on game save and native Social Media save.
- Runs the hourly billing alarm.
- Prioritizes active Verified subscribers in the native possible-contact picker.

## Data Model

Each record contains:

- `subscription_id`, `sim_id`, `account_id`
- `plan_id`, `plan_name`
- `status`
- `start_date`, `current_period_start`, `current_period_end`
- `next_billing_at`
- `last_successful_payment`, `payment_amount`
- `auto_renew`
- `cancellation_timestamp`, `expiration_timestamp`, `grace_period_end`
- last failure details and retry count
- `payment_history[]`

## Benefits

1. **Blue verification badge** — shown in the shared Social Bunny header while benefits are active.
2. **Verified account identification** — persisted account/subscription state and Verified screen labeling.
3. **Increased content visibility** — active Verified authors' native posts are stably prioritized in the feed.
4. **Priority recommendation** — active Verified Sims are preferred by the native possible-contact picker.
5. **Exclusive profile recognition** — badge + Verified account status persist across sessions.
6. **Subscriber notifications** — in-app activity feed and action results.
7. **Verified account status** — drives badge, feed priority, contact priority, and UI.

No fame or excessive popularity multiplier is granted.

## Timing

The game time API reports ticks at 25 real milliseconds per Sim second. One Sim day is `25 * 60 * 60 * 24 = 2,160,000` ticks.

Default plan:

- Price: §250
- Billing interval: 7 Sim days (`15,120,000` ticks)
- Grace: 2 Sim days
- Retry: every 12 Sim hours
- Renewal reminder: 24 Sim hours before renewal

All values are configurable through `verified_config.json`.
