"""Serializers for notifications."""
from __future__ import annotations

from rest_framework import serializers

from .models import Notification


class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = ["id", "recipient", "subject", "body", "read_at", "created_at", "updated_at"]
        read_only_fields = ["id", "read_at", "created_at", "updated_at"]
