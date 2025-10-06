"""Common serializers and utilities."""
from rest_framework import serializers


class TimeStampedSerializer(serializers.Serializer):
    created_at = serializers.DateTimeField(read_only=True)
    updated_at = serializers.DateTimeField(read_only=True)
