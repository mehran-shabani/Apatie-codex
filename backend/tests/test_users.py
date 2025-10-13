"""Tests for the custom user model."""

from __future__ import annotations

import pytest
from django.contrib.auth import get_user_model


@pytest.mark.django_db
def test_user_string_representation(user):
    assert str(user) == user.email


@pytest.mark.django_db
def test_create_superuser_flags():
    user_model = get_user_model()
    admin = user_model.objects.create_superuser(
        email="admin@example.com",
        password="SuperSecret123!",
    )

    assert admin.is_staff is True
    assert admin.is_superuser is True


@pytest.mark.django_db
def test_create_user_requires_email():
    user_model = get_user_model()

    with pytest.raises(ValueError):
        user_model.objects.create_user(email="", password="password")
