"""Shared pytest fixtures for the Django backend."""
from __future__ import annotations

import pytest
from django.conf import settings
from django.contrib.auth import get_user_model
from rest_framework.test import APIClient


@pytest.fixture
def api_client() -> APIClient:
    """Return a DRF API client for request testing."""
    return APIClient()


@pytest.fixture
def health_check_url() -> str:
    """Return the configured health check endpoint path."""
    return settings.HEALTH_CHECK_PATH


@pytest.fixture
def user_factory(db):
    """Factory for creating users with sensible defaults."""

    def create_user(**kwargs):
        password = kwargs.pop("password", "Passw0rd!")
        email = kwargs.pop("email", "user@example.com")

        user_model = get_user_model()
        user = user_model.objects.create_user(email=email, password=password, **kwargs)
        # Store the plain password for convenience in tests.
        user.raw_password = password  # type: ignore[attr-defined]
        return user

    return create_user


@pytest.fixture
def user(user_factory):
    """Create and return a default user instance."""
    return user_factory()
