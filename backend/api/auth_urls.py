"""Authentication endpoints for the API."""

from __future__ import annotations

from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView


app_name = "auth"

urlpatterns = [
    path("jwt/create/", TokenObtainPairView.as_view(), name="jwt-create"),
    path("jwt/refresh/", TokenRefreshView.as_view(), name="jwt-refresh"),
]
