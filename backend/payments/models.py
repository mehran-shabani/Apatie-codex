"""Payments domain models."""

from __future__ import annotations

from decimal import Decimal

from django.db import models

from appointments.models import Appointment
from common.models import TimeStampedModel


class PaymentTransaction(TimeStampedModel):
    appointment = models.ForeignKey(
        Appointment, on_delete=models.CASCADE, related_name="payments"
    )
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    currency = models.CharField(max_length=10, default="USD")
    status = models.CharField(max_length=20, default="pending")
    external_reference = models.CharField(max_length=255, blank=True)

    def mark_completed(self, reference: str):
        self.status = "completed"
        self.external_reference = reference
        self.save(update_fields=["status", "external_reference", "updated_at"])

    def __str__(self) -> str:  # pragma: no cover
        return f"Payment {self.pk} - {self.status}"

    @property
    def amount_decimal(self) -> Decimal:
        return Decimal(self.amount)
