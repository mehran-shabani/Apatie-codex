"""Test settings."""
from .base import *  # noqa: F401,F403

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": ":memory:",
    }
}

PASSWORD_HASHERS = ["django.contrib.auth.hashers.MD5PasswordHasher"]
CELERY_TASK_ALWAYS_EAGER = True
CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels.layers.InMemoryChannelLayer",
    }
}

MIGRATION_MODULES = {
    "common": None,
    "users": None,
    "business": None,
    "appointments": None,
    "marketplace": None,
    "services": None,
    "payments": None,
    "notifications": None,
}

MIDDLEWARE = [
    middleware
    for middleware in MIDDLEWARE
    if middleware != "django_guid.middleware.GuidMiddleware"
]
