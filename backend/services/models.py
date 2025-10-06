"""Services domain models."""
from __future__ import annotations

from django.db import models

from business.models import BusinessProfile
from common.models import TimeStampedModel


class Service(TimeStampedModel):
    business = models.ForeignKey(BusinessProfile, on_delete=models.CASCADE, related_name="services")
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    duration_minutes = models.PositiveIntegerField(default=60)

    def __str__(self) -> str:  # pragma: no cover
        return self.name
