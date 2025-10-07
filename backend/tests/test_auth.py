"""Authentication flow tests."""
from __future__ import annotations

import pytest
from django.urls import reverse


@pytest.mark.django_db
def test_jwt_auth_flow(api_client, user_factory):
    password = "StrongPass123!"
    user = user_factory(email="auth@example.com", password=password)

    token_url = reverse("token_obtain_pair")
    response = api_client.post(token_url, {"email": user.email, "password": password})

    assert response.status_code == 200
    tokens = response.json()
    assert "access" in tokens and "refresh" in tokens

    api_client.credentials(HTTP_AUTHORIZATION=f"Bearer {tokens['access']}")
    user_list_url = reverse("user-list")
    list_response = api_client.get(user_list_url)

    assert list_response.status_code == 200
    payload = list_response.json()
    assert any(item["email"] == user.email for item in payload)

    refresh_url = reverse("token_refresh")
    refresh_response = api_client.post(refresh_url, {"refresh": tokens["refresh"]})

    assert refresh_response.status_code == 200
    assert "access" in refresh_response.json()
