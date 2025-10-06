"""Appointments domain models."""
from __future__ import annotations

from django.conf import settings
from django.db import models

from business.models import BusinessProfile
from common.models import TimeStampedModel
from services.models import Service


class Appointment(TimeStampedModel):
    customer = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="appointments")
    business = models.ForeignKey(BusinessProfile, on_delete=models.CASCADE, related_name="appointments")
    service = models.ForeignKey(Service, on_delete=models.CASCADE, related_name="appointments")
    scheduled_for = models.DateTimeField()
    status = models.CharField(max_length=50, default="scheduled")
    notes = models.TextField(blank=True)

    def __str__(self) -> str:  # pragma: no cover
        return f"Appointment for {self.customer} on {self.scheduled_for:%Y-%m-%d %H:%M}"
