"""URL configuration for the Apatie project."""

from __future__ import annotations

from django.conf import settings
from django.contrib import admin
from django.http import JsonResponse
from django.urls import include, path
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView


def health_check_view(request):
    return JsonResponse({"status": "ok"})


urlpatterns = [
    path(settings.ADMIN_URL, admin.site.urls),
    path("api/auth/", include(("api.auth_urls", "auth"), namespace="api_auth")),
    path("api/v1/", include(("api.urls", "api"), namespace="api")),
    path("api/schema/", SpectacularAPIView.as_view(), name="schema"),
    path(
        "api/docs/", SpectacularSwaggerView.as_view(url_name="schema"), name="docs"
    ),
    path(
        settings.HEALTH_CHECK_PATH.lstrip("/"), health_check_view, name="health-check"
    ),
]
