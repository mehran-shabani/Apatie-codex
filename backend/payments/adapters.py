"""Payment provider adapters."""
from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
from typing import Any, Dict


class PaymentStatus(Enum):
    PENDING = "pending"
    COMPLETED = "completed"
    FAILED = "failed"


@dataclass
class PaymentResult:
    reference: str
    status: PaymentStatus
    details: Dict[str, Any]


class MockPaymentGateway:
    """In-memory gateway used for local development and tests."""

    def charge(self, *, amount: float, currency: str, metadata: Dict[str, Any] | None = None) -> PaymentResult:
        metadata = metadata or {}
        reference = metadata.get("reference", "mock-reference")
        return PaymentResult(reference=reference, status=PaymentStatus.COMPLETED, details={"amount": amount, "currency": currency})
