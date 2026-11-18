# Changelog — Social Bunny Verified

## Unreleased

- Preserve unsaved Verified subscription changes when loading a zone or switching save slots.
- Ensure native Social Bunny follower recounts grant at least one follower when the game's calculation produces no increase.

## v2.0.0 — Additive Verified tab

- Restored all vanilla Social Bunny ActionScript except `SocialMediaPanel.as`.
- Added exactly one new native navigation tab, **Verified**, after Message.
- Reused the native tab button skin, native content-panel MovieClip backdrop, native fonts, and native button components.
- Added a full subscription screen with status, eligibility, price, interval, benefits, confirmation, management, payment history, and account activity.
- Added persistent subscription records with schema versioning and migration.
- Added Simoleon billing with explicit confirmation, automatic renewal, retries, grace periods, suspension, cancellation, expiration, and reactivation.
- Added verified benefits: blue header badge, feed prioritization, native contact-picker priority, account labeling, and subscriber activity notifications.
- Replaced the previous UI package payload with a single targeted GFX override:
  - `62ECC59A:00000000:8ABB350F01880C64`
- Removed the unused Core package and custom texture resources from the deliverables.

## v1.0.0 — Previous overhaul (superseded)

The earlier 6-tab interface replaced the vanilla Social Bunny interface. It has been superseded by the additive v2 implementation to preserve vanilla Feed, Friends, and Message behavior.
