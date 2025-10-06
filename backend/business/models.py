"""Business domain models."""
from __future__ import annotations

from django.conf import settings
from django.db import models

from common.models import TimeStampedModel


class BusinessProfile(TimeStampedModel):
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="businesses")
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True)

    def __str__(self) -> str:  # pragma: no cover - simple representation
        return self.name
