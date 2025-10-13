"""API URL configuration."""

from __future__ import annotations

from django.urls import include, path

from api.routers import router

app_name = "api"

urlpatterns = [
    path("", include(router.urls)),
]
