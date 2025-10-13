"""API URL configuration."""

from __future__ import annotations

from django.urls import include, path
from rest_framework import routers
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from drf_spectacular.views import (
    SpectacularAPIView,
    SpectacularRedocView,
    SpectacularSwaggerView,
)

from appointments.viewsets import AppointmentViewSet
from business.viewsets import BusinessProfileViewSet
from marketplace.viewsets import ListingViewSet
from notifications.viewsets import NotificationViewSet
from payments.viewsets import PaymentTransactionViewSet
from services.viewsets import ServiceViewSet
from users.viewsets import UserViewSet

router = routers.DefaultRouter()
router.register(r"v1/users", UserViewSet, basename="user")
router.register(r"v1/businesses", BusinessProfileViewSet, basename="business")
router.register(r"v1/services", ServiceViewSet, basename="service")
router.register(r"v1/listings", ListingViewSet, basename="listing")
router.register(r"v1/appointments", AppointmentViewSet, basename="appointment")
router.register(r"v1/payments", PaymentTransactionViewSet, basename="payment")
router.register(r"v1/notifications", NotificationViewSet, basename="notification")

urlpatterns = [
    path("v1/token/", TokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("v1/token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),
    path("schema/", SpectacularAPIView.as_view(), name="schema"),
    path(
        "schema/swagger/",
        SpectacularSwaggerView.as_view(url_name="schema"),
        name="swagger-ui",
    ),
    path(
        "schema/redoc/", SpectacularRedocView.as_view(url_name="schema"), name="redoc"
    ),
    path("", include(router.urls)),
]
