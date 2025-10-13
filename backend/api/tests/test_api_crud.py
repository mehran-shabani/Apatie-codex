"""End-to-end CRUD tests for public API resources."""

from __future__ import annotations

from decimal import Decimal

import pytest
from django.urls import reverse

from business.models import BusinessProfile
from marketplace.models import Listing
from services.models import Service


@pytest.fixture
def owner(user_factory):
    """Return a user that owns the seeded business."""

    return user_factory(email="owner-crud@example.com")


@pytest.fixture
def business(owner):
    """Create a business profile owned by the authenticated user."""

    return BusinessProfile.objects.create(
        owner=owner,
        name="Integration Business",
        description="Business generated for API CRUD tests.",
    )


@pytest.fixture
def service(business):
    """Create a service offered by the seeded business."""

    return Service.objects.create(
        business=business,
        name="Consultation",
        description="Standard consultation service.",
        duration_minutes=45,
    )


@pytest.mark.django_db
def test_listing_crud_lifecycle(api_client, owner, business, service):
    """Ensure listings can be created, read, updated and deleted."""

    api_client.force_authenticate(owner)

    list_url = reverse("api:listings-list")
    create_payload = {
        "business": business.pk,
        "service": service.pk,
        "price": "79.99",
        "is_active": True,
    }

    create_response = api_client.post(list_url, data=create_payload, format="json")
    assert create_response.status_code == 201
    created = create_response.json()
    listing_id = created["id"]

    detail_url = reverse("api:listings-detail", args=[listing_id])
    retrieve_response = api_client.get(detail_url)
    assert retrieve_response.status_code == 200
    retrieved = retrieve_response.json()
    assert retrieved["business"] == business.pk
    assert retrieved["service"] == service.pk
    assert Decimal(str(retrieved["price"])) == Decimal("79.99")
    assert retrieved["is_active"] is True

    patch_payload = {"price": "59.50", "is_active": False}
    update_response = api_client.patch(detail_url, data=patch_payload, format="json")
    assert update_response.status_code == 200
    updated = update_response.json()
    assert Decimal(str(updated["price"])) == Decimal("59.50")
    assert updated["is_active"] is False

    list_response = api_client.get(list_url)
    assert list_response.status_code == 200
    payload = list_response.json()
    results = payload.get("results", payload)
    assert any(item["id"] == listing_id for item in results)

    delete_response = api_client.delete(detail_url)
    assert delete_response.status_code == 204
    assert not Listing.objects.filter(pk=listing_id).exists()


@pytest.mark.django_db
def test_listing_requires_authentication(api_client):
    """Anonymous users should be rejected when accessing protected endpoints."""

    response = api_client.get(reverse("api:listings-list"))

    assert response.status_code in {401, 403}
    payload = response.json()
    assert payload.get("detail")
