"""Production ready settings for the Apatie backend project."""

from __future__ import annotations

import secrets

from django.core.exceptions import ImproperlyConfigured

from .base import *  # noqa: F401,F403


DEBUG = False


def _resolve_secret_key() -> str:
    """Ensure a cryptographically strong SECRET_KEY is available."""

    if SECRET_KEY != "change-me":
        return SECRET_KEY

    # Try dedicated environment variable first to avoid reusing the insecure
    # development default when the deployment configuration forgets to supply
    # one.
    provided = ENV.str("DJANGO_SECRET_KEY", default=None)
    if provided:
        return provided

    provided = ENV.str("SECRET_KEY", default=None)
    if provided and provided != "change-me":
        return provided

    # Fallback to a random key so that ``check --deploy`` and other
    # management commands executed in CI still have a secure value available.
    # Real deployments should still provide the key through an environment
    # variable to maintain session persistence.
    return secrets.token_urlsafe(64)


SECRET_KEY = _resolve_secret_key()

# Keep JWT signing key consistent with the resolved secret key to avoid
# using the insecure development default when SECRET_KEY is regenerated.
SIMPLE_JWT["SIGNING_KEY"] = SECRET_KEY


DEFAULT_ALLOWED_HOSTS = ["apatie.example"]
ALLOWED_HOSTS = ENV.list("ALLOWED_HOSTS", default=DEFAULT_ALLOWED_HOSTS)
if not ALLOWED_HOSTS or ALLOWED_HOSTS == ["*"]:
    raise ImproperlyConfigured(
        "ALLOWED_HOSTS must be configured with concrete domains in production."
    )


# Security hardening recommended for public deployments.
SECURE_SSL_REDIRECT = True
SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
SECURE_HSTS_SECONDS = ENV.int("SECURE_HSTS_SECONDS", default=31536000)
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True

SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
CSRF_COOKIE_SAMESITE = "Lax"

REFERRER_POLICY = "strict-origin-when-cross-origin"

USE_X_FORWARDED_HOST = True

