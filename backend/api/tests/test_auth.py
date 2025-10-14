"""Authentication helper tests for the public API."""

from __future__ import annotations

import secrets

import pytest
from django.urls import reverse

from backend.tests.utils import extract_results


@pytest.mark.django_db
def test_jwt_authentication_flow(api_client, user_factory):
    """Exercise the token obtain/refresh endpoints exposed by the API."""

    password = secrets.token_urlsafe(16)
    user = user_factory(email="api-auth@example.com", password=password)

    token_url = reverse("api_auth:jwt-create")
    response = api_client.post(token_url, {"email": user.email, "password": password})

    assert response.status_code == 200
    tokens = response.json()
    assert "access" in tokens and "refresh" in tokens

    api_client.credentials(HTTP_AUTHORIZATION=f"Bearer {tokens['access']}")
    user_list_url = reverse("api:users-list")
    list_response = api_client.get(user_list_url)

    assert list_response.status_code == 200
    payload = extract_results(list_response.json())
    assert any(item["email"] == user.email for item in payload)

    refresh_url = reverse("api_auth:jwt-refresh")
    refresh_response = api_client.post(refresh_url, {"refresh": tokens["refresh"]})

    assert refresh_response.status_code == 200
    refreshed = refresh_response.json()
    assert "access" in refreshed and refreshed["access"]


@pytest.mark.django_db
def test_jwt_authentication_rejects_bad_credentials(api_client):
    """Ensure invalid credentials do not yield tokens."""

    token_url = reverse("api_auth:jwt-create")
    response = api_client.post(token_url, {"email": "nobody@example.com", "password": "bad"})

    assert response.status_code in {400, 401}
    payload = response.json()
    assert payload.get("detail") or payload.get("non_field_errors")
