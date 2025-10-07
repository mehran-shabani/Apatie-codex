"""Tests for the backend health check endpoint."""
from __future__ import annotations

import pytest


@pytest.mark.django_db
def test_health_endpoint_returns_ok(client, health_check_url):
    response = client.get(health_check_url)

    assert response.status_code == 200
    assert response.json() == {"status": "ok"}
