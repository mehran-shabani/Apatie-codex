"""Logging configuration for the Apatie backend."""

from __future__ import annotations

import logging
import os
from typing import Any, Dict

LOG_LEVEL = os.getenv("DJANGO_LOG_LEVEL", "INFO")

LOGGING: Dict[str, Any] = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "verbose": {
            "format": "%(levelname)s %(asctime)s %(name)s [%(request_id)s] %(message)s",
        },
        "simple": {
            "format": "%(levelname)s %(message)s",
        },
    },
    "filters": {
        "request_id": {
            "()": "django_guid.log_filters.CorrelationId",  # falls back gracefully if middleware missing
            "correlation_id_field": "request_id",
        }
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "formatter": "verbose",
            "filters": ["request_id"],
        }
    },
    "loggers": {
        "django": {
            "handlers": ["console"],
            "level": LOG_LEVEL,
        },
        "apatie.audit": {
            "handlers": ["console"],
            "level": "INFO",
            "propagate": False,
        },
    },
}

# Configure an audit logger helper
AUDIT_LOGGER = logging.getLogger("apatie.audit")
