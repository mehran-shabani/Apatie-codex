"""Marketplace domain models."""
from __future__ import annotations

from django.db import models

from business.models import BusinessProfile
from common.models import TimeStampedModel
from services.models import Service


class Listing(TimeStampedModel):
    business = models.ForeignKey(BusinessProfile, on_delete=models.CASCADE, related_name="listings")
    service = models.ForeignKey(Service, on_delete=models.CASCADE, related_name="listings")
    price = models.DecimalField(max_digits=10, decimal_places=2)
    is_active = models.BooleanField(default=True)

    def __str__(self) -> str:  # pragma: no cover
        return f"{self.service} - {self.price}"
