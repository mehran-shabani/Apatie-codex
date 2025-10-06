"""Notification service adapters."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Dict


@dataclass
class NotificationResult:
    success: bool
    message: str


class MockNotificationService:
    """Simple in-memory notification delivery."""

    sent_messages: list[Dict[str, str]] = []

    def send(self, *, recipient: str, subject: str, body: str) -> NotificationResult:
        payload = {"recipient": recipient, "subject": subject, "body": body}
        self.sent_messages.append(payload)
        return NotificationResult(success=True, message="queued")
