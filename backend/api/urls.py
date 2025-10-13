"""API URL configuration."""

from __future__ import annotations

from django.urls import include, path
from rest_framework import routers

from appointments.viewsets import AppointmentViewSet
from business.viewsets import BusinessProfileViewSet
from marketplace.viewsets import ListingViewSet
from notifications.viewsets import NotificationViewSet
from payments.viewsets import PaymentTransactionViewSet
from services.viewsets import ServiceViewSet
from users.viewsets import UserViewSet

app_name = "api"

router = routers.DefaultRouter()
router.register(r"users", UserViewSet, basename="user")
router.register(r"businesses", BusinessProfileViewSet, basename="business")
router.register(r"services", ServiceViewSet, basename="service")
router.register(r"listings", ListingViewSet, basename="listing")
router.register(r"appointments", AppointmentViewSet, basename="appointment")
router.register(r"payments", PaymentTransactionViewSet, basename="payment")
router.register(r"notifications", NotificationViewSet, basename="notification")

urlpatterns = [
    path("", include(router.urls)),
]
