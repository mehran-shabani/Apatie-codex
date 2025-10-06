"""Notification domain models."""
from __future__ import annotations

from django.conf import settings
from django.db import models

from common.models import TimeStampedModel


class Notification(TimeStampedModel):
    recipient = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="notifications")
    subject = models.CharField(max_length=255)
    body = models.TextField()
    read_at = models.DateTimeField(null=True, blank=True)

    def mark_read(self):
        from django.utils import timezone

        self.read_at = timezone.now()
        self.save(update_fields=["read_at", "updated_at"])

    def __str__(self) -> str:  # pragma: no cover
        return f"Notification to {self.recipient}"
