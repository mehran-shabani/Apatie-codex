"""Base settings for the Apatie backend project."""

from __future__ import annotations

from datetime import timedelta
from pathlib import Path

import environ

BASE_DIR = Path(__file__).resolve().parent.parent.parent
DEFAULT_SQLITE_PATH = BASE_DIR / "db.sqlite3"
DEFAULT_SQLITE_URL = f"sqlite:///{DEFAULT_SQLITE_PATH.as_posix()}"

# Load environment variables
ENV = environ.Env(
    DEBUG=(bool, False),
    SECRET_KEY=(str, "change-me"),
    ALLOWED_HOSTS=(list, ["*"]),
    DATABASE_URL=(str, DEFAULT_SQLITE_URL),
    REDIS_URL=(str, ""),
    CORS_ALLOWED_ORIGINS=(list, []),
    CSRF_TRUSTED_ORIGINS=(list, []),
    DJANGO_LOG_LEVEL=(str, "INFO"),
    DJANGO_ADMIN_URL=(str, "admin/"),
)

env_file = BASE_DIR / ".env"
if env_file.exists():
    environ.Env.read_env(str(env_file))

SECRET_KEY = ENV("SECRET_KEY")
DEBUG = ENV("DEBUG")
ALLOWED_HOSTS = ENV.list("ALLOWED_HOSTS")
ADMIN_URL = ENV("DJANGO_ADMIN_URL")
REDIS_URL = ENV.str("REDIS_URL", default="")

# Applications
DJANGO_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
]

THIRD_PARTY_APPS = [
    "rest_framework",
    "rest_framework.authtoken",
    "rest_framework_simplejwt",
    "corsheaders",
    "django_guid",
    "drf_spectacular",
    "django_filters",
    "channels",
]

LOCAL_APPS = [
    "common",
    "users",
    "business",
    "appointments",
    "marketplace",
    "services",
    "payments",
    "notifications",
]

INSTALLED_APPS = DJANGO_APPS + THIRD_PARTY_APPS + LOCAL_APPS

MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "django_guid.middleware.guid_middleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "core.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / "templates"],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "core.wsgi.application"
ASGI_APPLICATION = "core.asgi.application"

# Database
DATABASES = {
    "default": ENV.db("DATABASE_URL", default=DEFAULT_SQLITE_URL),
}

# Authentication
AUTH_USER_MODEL = "users.User"

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"
    },
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

# Internationalization
LANGUAGE_CODE = "en-us"
TIME_ZONE = "UTC"
USE_I18N = True
USE_TZ = True

# Static & Media
STATIC_URL = "/static/"
STATIC_ROOT = BASE_DIR / "staticfiles"
MEDIA_URL = "/media/"
MEDIA_ROOT = BASE_DIR / "media"

# REST Framework
REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": (
        "rest_framework.authentication.SessionAuthentication",
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ),
    "DEFAULT_PERMISSION_CLASSES": (
        "rest_framework.permissions.IsAuthenticatedOrReadOnly",
    ),
    "DEFAULT_RENDERER_CLASSES": ("rest_framework.renderers.JSONRenderer",),
    "DEFAULT_PAGINATION_CLASS": "backend.api.pagination.DefaultPagination",
    "DEFAULT_SCHEMA_CLASS": "drf_spectacular.openapi.AutoSchema",
    "DEFAULT_VERSIONING_CLASS": "rest_framework.versioning.URLPathVersioning",
    "DEFAULT_FILTER_BACKENDS": (
        "django_filters.rest_framework.DjangoFilterBackend",
        "rest_framework.filters.SearchFilter",
        "rest_framework.filters.OrderingFilter",
    ),
    "DEFAULT_THROTTLE_CLASSES": (
        "rest_framework.throttling.AnonRateThrottle",
        "rest_framework.throttling.UserRateThrottle",
    ),
    "DEFAULT_THROTTLE_RATES": {
        "anon": "60/min",
        "user": "120/min",
    },
    "PAGE_SIZE": 10,
}

REST_FRAMEWORK["DEFAULT_THROTTLE_RATES"]["user"] = ENV.str(
    "REST_FRAMEWORK__DEFAULT_THROTTLE_RATES__USER",
    default=REST_FRAMEWORK["DEFAULT_THROTTLE_RATES"]["user"],
)
REST_FRAMEWORK["DEFAULT_THROTTLE_RATES"]["anon"] = ENV.str(
    "REST_FRAMEWORK__DEFAULT_THROTTLE_RATES__ANON",
    default=REST_FRAMEWORK["DEFAULT_THROTTLE_RATES"]["anon"],
)

SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(minutes=15),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=1),
    "ROTATE_REFRESH_TOKENS": True,
    "BLACKLIST_AFTER_ROTATION": True,
    "ALGORITHM": "HS256",
    "SIGNING_KEY": SECRET_KEY,
}

SPECTACULAR_SETTINGS = {
    "TITLE": "Apatie API",
    "DESCRIPTION": "Comprehensive API specification for the Apatie platform.",
    "VERSION": "1.0.0",
    "SERVE_INCLUDE_SCHEMA": False,
    "COMPONENT_SPLIT_REQUEST": True,
    "SCHEMA_PATH_PREFIX": r"/api/v[0-9]+",
    "SERVE_PERMISSIONS": ("rest_framework.permissions.AllowAny",),
    "SERVE_AUTHENTICATION": (
        "rest_framework.authentication.SessionAuthentication",
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ),
    "CONTACT": {"name": "Apatie", "email": "support@apatie.example"},
    "LICENSE": {"name": "Proprietary"},
}

# CORS / CSRF
CORS_ALLOWED_ORIGINS = ENV.list("CORS_ALLOWED_ORIGINS")
CORS_ALLOW_CREDENTIALS = True
CSRF_TRUSTED_ORIGINS = ENV.list("CSRF_TRUSTED_ORIGINS")

# Channels configuration
if REDIS_URL:
    CHANNEL_LAYERS = {
        "default": {
            "BACKEND": "channels_redis.core.RedisChannelLayer",
            "CONFIG": {
                "hosts": [REDIS_URL],
            },
        }
    }
else:
    CHANNEL_LAYERS = {
        "default": {
            "BACKEND": "channels.layers.InMemoryChannelLayer",
        }
    }

# Celery configuration
CELERY_BROKER_URL = REDIS_URL or "memory://"
CELERY_RESULT_BACKEND = REDIS_URL or "cache+memory://"
CELERY_TASK_ALWAYS_EAGER = not REDIS_URL
CELERY_TASK_TIME_LIMIT = 30 * 60
CELERY_ACCEPT_CONTENT = ["json"]
CELERY_TASK_SERIALIZER = "json"
CELERY_RESULT_SERIALIZER = "json"

# Email backend (console for now)
EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"

# Logging configuration is split out for readability
from .logging import LOGGING  # noqa: E402  pylint: disable=wrong-import-position

# Health check path
HEALTH_CHECK_PATH = "/healthz"

# Default primary key field type
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"
