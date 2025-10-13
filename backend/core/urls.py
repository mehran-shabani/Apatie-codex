"""URL configuration for the Apatie project."""

from __future__ import annotations

from django.conf import settings
from django.contrib import admin
from django.http import JsonResponse
from django.urls import include, path


def health_check_view(request):
    return JsonResponse({"status": "ok"})


urlpatterns = [
    path(settings.ADMIN_URL, admin.site.urls),
    path("api/", include("api.urls")),
    path(
        settings.HEALTH_CHECK_PATH.lstrip("/"), health_check_view, name="health-check"
    ),
]
