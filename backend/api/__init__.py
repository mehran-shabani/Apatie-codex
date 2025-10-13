"""Public API utilities and viewsets."""

from __future__ import annotations

__all__ = [
    "DefaultPagination",
    "IsOwnerOrReadOnly",
    "AutoModelViewSet",
    "AppointmentViewSet",
    "BusinessProfileViewSet",
    "ListingViewSet",
    "NotificationViewSet",
    "PaymentTransactionViewSet",
    "ServiceViewSet",
    "UserViewSet",
]


def __getattr__(name: str):
    if name == "DefaultPagination":
        from api.pagination import DefaultPagination as attr

        return attr
    if name == "IsOwnerOrReadOnly":
        from api.permissions import IsOwnerOrReadOnly as attr

        return attr
    if name in {
        "AutoModelViewSet",
        "AppointmentViewSet",
        "BusinessProfileViewSet",
        "ListingViewSet",
        "NotificationViewSet",
        "PaymentTransactionViewSet",
        "ServiceViewSet",
        "UserViewSet",
    }:
        from api import viewsets as viewsets_module

        return getattr(viewsets_module, name)
    raise AttributeError(name)
