"""Reusable permission classes for the API."""

from __future__ import annotations

from typing import Any

from django.contrib.auth import get_user_model
from rest_framework import permissions

__all__ = ["IsOwnerOrReadOnly"]


class IsOwnerOrReadOnly(permissions.BasePermission):
    """Allow edits only for object owners while staff retain full access."""

    owner_attribute = "owner"

    def has_object_permission(self, request, view, obj):  # type: ignore[override]
        if request.method in permissions.SAFE_METHODS:
            return True

        if getattr(request.user, "is_staff", False):
            return True

        owner_lookup_attributes = [
            getattr(view, "owner_attribute", self.owner_attribute),
            "user",
            "recipient",
            "customer",
        ]

        owner: Any = None
        for attr in owner_lookup_attributes:
            candidate = getattr(obj, attr, None)
            if candidate is not None:
                owner = candidate
                break

        if owner is None:
            return False

        if isinstance(owner, get_user_model()):
            return owner == request.user

        if hasattr(owner, "pk"):
            return owner.pk == getattr(request.user, "pk", None)

        return owner == request.user
