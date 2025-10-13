"""Router configuration for the public API."""

from __future__ import annotations

from rest_framework.routers import DefaultRouter

from api.viewsets import (
    AppointmentViewSet,
    BusinessProfileViewSet,
    ListingViewSet,
    NotificationViewSet,
    PaymentTransactionViewSet,
    ServiceViewSet,
    UserViewSet,
)

__all__ = ["router"]

router = DefaultRouter()
router.register("users", UserViewSet, basename="users")
router.register("businesses", BusinessProfileViewSet, basename="businesses")
router.register("services", ServiceViewSet, basename="services")
router.register("listings", ListingViewSet, basename="listings")
router.register("appointments", AppointmentViewSet, basename="appointments")
router.register("payments", PaymentTransactionViewSet, basename="payments")
router.register("notifications", NotificationViewSet, basename="notifications")
