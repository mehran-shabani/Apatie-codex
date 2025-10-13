"""Serializers for marketplace resources."""

from __future__ import annotations

from rest_framework import serializers

from .models import Listing


class ListingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Listing
        fields = [
            "id",
            "business",
            "service",
            "price",
            "is_active",
            "created_at",
            "updated_at",
        ]
        read_only_fields = ["id", "created_at", "updated_at"]
