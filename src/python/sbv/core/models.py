# -*- coding: utf-8 -*-
"""Shared enums, constants, and configuration defaults for Social Bunny Verified."""

SCHEMA_VERSION = 1
MOD_VERSION = "1.0.0"

# Post types used as internal state packets in ShowSocialMediaDialog
PACKET_TYPE_CORE_STATE = 100
PACKET_TYPE_POSTS_CHUNK = 101
PACKET_TYPE_GRAPH_CHUNK = 102
PACKET_TYPE_EXTRA_CHUNK = 103

# Base game {0.String} STBL hash verified in Data/Client/Strings_ENG_US.package
RAW_TEXT_STBL_HASH = 0x2039BFC9


class AccountCategory(object):
    PERSONAL = "personal"
    CREATOR = "creator"
    BUSINESS = "business"
    PUBLIC_FIGURE = "public_figure"
    OFFICIAL_ORG = "official_org"

    ALL = (PERSONAL, CREATOR, BUSINESS, PUBLIC_FIGURE, OFFICIAL_ORG)

    LABELS = {
        PERSONAL: "Personal",
        CREATOR: "Creator",
        BUSINESS: "Business",
        PUBLIC_FIGURE: "Public Figure",
        OFFICIAL_ORG: "Official Organization",
    }


class AccountPrivacy(object):
    PUBLIC = "public"
    PRIVATE = "private"
    ALL = (PUBLIC, PRIVATE)


class AccountStatus(object):
    ACTIVE = "active"
    RESTRICTED = "restricted"
    SUSPENDED = "suspended"


class VerificationTier(object):
    NONE = "none"
    BLUE_VERIFIED = "blue_verified"
    OFFICIAL = "official"
    CREATOR = "creator"
    LEGACY = "legacy"

    ALL = (NONE, BLUE_VERIFIED, OFFICIAL, CREATOR, LEGACY)

    LABELS = {
        NONE: "Unverified",
        BLUE_VERIFIED: "Blue Verified",
        OFFICIAL: "Official",
        CREATOR: "Creator",
        LEGACY: "Legacy Verified",
    }


class ApplicationStatus(object):
    NOT_ELIGIBLE = "not_eligible"
    ELIGIBLE = "eligible"
    PENDING = "pending"
    UNDER_REVIEW = "under_review"
    VERIFIED = "verified"
    REJECTED = "rejected"
    SUSPENDED = "suspended"
    REVOKED = "revoked"


class PostType(object):
    TEXT = "text"
    PHOTO = "photo"
    MOOD = "mood"
    LIFE_EVENT = "life_event"
    ACHIEVEMENT = "achievement"
    RELATIONSHIP = "relationship"
    MILESTONE = "milestone"
    SPONSORED = "sponsored"
    TRENDING = "trending"
    CONTROVERSIAL = "controversial"

    ALL = (
        TEXT,
        PHOTO,
        MOOD,
        LIFE_EVENT,
        ACHIEVEMENT,
        RELATIONSHIP,
        MILESTONE,
        SPONSORED,
        TRENDING,
        CONTROVERSIAL,
    )


class NotificationType(object):
    LIKE = "like"
    COMMENT = "comment"
    REPLY = "reply"
    FOLLOW = "follow"
    FOLLOW_REQUEST = "follow_request"
    FOLLOW_ACCEPTED = "follow_accepted"
    VERIFICATION = "verification"
    BRAND_OFFER = "brand_offer"
    MODERATION = "moderation"
    CONTROVERSY = "controversy"


class ModerationAction(object):
    NONE = "none"
    WARNING = "warning"
    CONTENT_REMOVAL = "content_removal"
    TEMP_RESTRICTION = "temp_restriction"
    TEMP_SUSPENSION = "temp_suspension"
    BADGE_SUSPENDED = "badge_suspended"
    VERIFICATION_REVOKED = "verification_revoked"


class BrandOfferStatus(object):
    OFFERED = "offered"
    NEGOTIATING = "negotiating"
    ACCEPTED = "accepted"
    REJECTED = "rejected"
    COMPLETED = "completed"
    CANCELLED = "cancelled"


DEFAULT_VERIFICATION_CONFIG = {
    "weights": {
        "authenticity": 0.20,
        "notability": 0.25,
        "activity": 0.15,
        "engagement_quality": 0.15,
        "reputation": 0.15,
        "profile_quality": 0.10,
    },
    "thresholds": {
        AccountCategory.PERSONAL: 72.0,
        AccountCategory.CREATOR: 68.0,
        AccountCategory.BUSINESS: 65.0,
        AccountCategory.PUBLIC_FIGURE: 60.0,
        AccountCategory.OFFICIAL_ORG: 64.0,
    },
    "reapplication_cooldown_hours": 48,
    "review_delay_hours": 6,
    "min_reputation_for_verification": 40.0,
    "min_posts_for_verification": 3,
}

DEFAULT_ENGAGEMENT_CONFIG = {
    "like_weight": 1.0,
    "comment_weight": 2.0,
    "share_weight": 3.0,
}
