"""Authentication flow tests."""

from __future__ import annotations

import pytest
from django.urls import reverse


@pytest.mark.django_db
def test_jwt_auth_flow(api_client, user_factory):
    password = "StrongPass123!"
    user = user_factory(email="auth@example.com", password=password)

    token_url = reverse("api_auth:jwt-create")
    response = api_client.post(token_url, {"email": user.email, "password": password})

    assert response.status_code == 200
    tokens = response.json()
    assert "access" in tokens and "refresh" in tokens

    api_client.credentials(HTTP_AUTHORIZATION=f"Bearer {tokens['access']}")
    user_list_url = reverse("api:user-list")
    list_response = api_client.get(user_list_url)

    assert list_response.status_code == 200
    payload = list_response.json()
    if isinstance(payload, dict) and "results" in payload:
        payload = payload["results"]
    assert any(item["email"] == user.email for item in payload)

    refresh_url = reverse("api_auth:jwt-refresh")
    refresh_response = api_client.post(refresh_url, {"refresh": tokens["refresh"]})

    assert refresh_response.status_code == 200
    assert "access" in refresh_response.json()
