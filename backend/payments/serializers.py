"""Serializers for payment resources."""
from __future__ import annotations

from rest_framework import serializers

from .models import PaymentTransaction


class PaymentTransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = PaymentTransaction
        fields = [
            "id",
            "appointment",
            "amount",
            "currency",
            "status",
            "external_reference",
            "created_at",
            "updated_at",
        ]
        read_only_fields = ["id", "status", "external_reference", "created_at", "updated_at"]
