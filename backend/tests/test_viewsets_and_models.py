"""Comprehensive API and model tests for key domain resources."""

from __future__ import annotations

import json
from pathlib import Path

import pytest
from django.urls import reverse
from rest_framework import status

from api.viewsets import NotificationViewSet, PaymentTransactionViewSet
from business.models import BusinessProfile
from notifications.adapters import NotificationResult
from payments.adapters import MockPaymentGateway, PaymentResult, PaymentStatus


def extract_results(payload):
    """Return the result list from paginated responses."""

    if isinstance(payload, dict) and "results" in payload:
        return payload["results"]
    return payload


@pytest.mark.django_db
def test_appointment_queryset_scoped_for_regular_users(
    api_client, appointment_factory, user_factory
):
    customer = user_factory(email="customer@example.com")
    other_customer = user_factory(email="other-customer@example.com")
    customer_appointment = appointment_factory(customer=customer)
    appointment_factory(customer=other_customer)

    api_client.force_authenticate(customer)
    response = api_client.get(reverse("api:appointments-list"))

    assert response.status_code == 200
    appointment_ids = {item["id"] for item in extract_results(response.json())}
    assert appointment_ids == {customer_appointment.id}


@pytest.mark.django_db
def test_anonymous_user_cannot_list_business_profiles(api_client):
    response = api_client.get(reverse("api:businesses-list"))

    assert response.status_code in {
        status.HTTP_401_UNAUTHORIZED,
        status.HTTP_403_FORBIDDEN,
    }
    payload = response.json()
    assert payload.get("detail")


@pytest.mark.django_db
def test_anonymous_user_cannot_retrieve_business_profile(
    api_client, business_profile_factory
):
    profile = business_profile_factory()

    response = api_client.get(reverse("api:businesses-detail", args=[profile.pk]))

    assert response.status_code in {
        status.HTTP_401_UNAUTHORIZED,
        status.HTTP_403_FORBIDDEN,
    }
    payload = response.json()
    assert payload.get("detail")


@pytest.mark.django_db
def test_appointment_queryset_visible_to_staff(api_client, appointment_factory, user_factory):
    staff_user = user_factory(email="staff@example.com", is_staff=True)
    first_appointment = appointment_factory()
    second_appointment = appointment_factory()

    api_client.force_authenticate(staff_user)
    response = api_client.get(reverse("api:appointments-list"))

    assert response.status_code == 200
    appointment_ids = {item["id"] for item in extract_results(response.json())}
    assert appointment_ids == {first_appointment.id, second_appointment.id}


@pytest.mark.django_db
def test_service_queryset_filtered_for_business_owner(
    api_client, service_factory, business_profile_factory, user_factory
):
    owner = user_factory(email="owner@example.com")
    other_owner = user_factory(email="other-owner@example.com")

    owned_business = business_profile_factory(owner=owner)
    owned_service = service_factory(business=owned_business)
    service_factory(business=business_profile_factory(owner=other_owner))

    api_client.force_authenticate(owner)
    response = api_client.get(reverse("api:services-list"))

    assert response.status_code == 200
    service_ids = {item["id"] for item in extract_results(response.json())}
    assert service_ids == {owned_service.id}


@pytest.mark.django_db
def test_service_queryset_visible_to_staff(api_client, service_factory, user_factory):
    staff_user = user_factory(email="staff-services@example.com", is_staff=True)
    service_one = service_factory()
    service_two = service_factory()

    api_client.force_authenticate(staff_user)
    response = api_client.get(reverse("api:services-list"))

    assert response.status_code == 200
    service_ids = {item["id"] for item in extract_results(response.json())}
    assert service_ids == {service_one.id, service_two.id}


@pytest.mark.django_db
def test_listing_queryset_filtered_for_business_owner(
    api_client, listing_factory, business_profile_factory, service_factory, user_factory
):
    owner = user_factory(email="listing-owner@example.com")
    other_owner = user_factory(email="listing-other@example.com")

    owned_business = business_profile_factory(owner=owner)
    owned_service = service_factory(business=owned_business)
    owned_listing = listing_factory(service=owned_service, business=owned_business)

    other_business = business_profile_factory(owner=other_owner)
    other_service = service_factory(business=other_business)
    listing_factory(service=other_service, business=other_business)

    api_client.force_authenticate(owner)
    response = api_client.get(reverse("api:listings-list"))

    assert response.status_code == 200
    listing_ids = {item["id"] for item in extract_results(response.json())}
    assert listing_ids == {owned_listing.id}


@pytest.mark.django_db
def test_listing_queryset_visible_to_staff(api_client, listing_factory, user_factory):
    staff_user = user_factory(email="staff-listings@example.com", is_staff=True)
    listing_one = listing_factory()
    listing_two = listing_factory()

    api_client.force_authenticate(staff_user)
    response = api_client.get(reverse("api:listings-list"))

    assert response.status_code == 200
    listing_ids = {item["id"] for item in extract_results(response.json())}
    assert listing_ids == {listing_one.id, listing_two.id}


@pytest.mark.django_db
def test_business_profile_owner_is_request_user(api_client, user_factory):
    authenticated_user = user_factory(email="creator@example.com")
    other_user = user_factory(email="other@example.com")

    api_client.force_authenticate(authenticated_user)
    response = api_client.post(
        reverse("api:businesses-list"),
        data={
            "name": "Creator Business",
            "description": "Created via API",
            "owner": other_user.id,
        },
        format="json",
    )

    assert response.status_code == 201
    payload = response.json()
    assert payload["owner"] == authenticated_user.id
    created_profile = BusinessProfile.objects.get(pk=payload["id"])
    assert created_profile.owner == authenticated_user


@pytest.mark.django_db
def test_notification_send_test_action_invokes_adapter(
    api_client, user_factory, monkeypatch
):
    class DummyNotificationService:
        calls: list[dict[str, str]] = []

        def __init__(self):
            self.__class__.calls.clear()

        def send(self, *, recipient: str, subject: str, body: str) -> NotificationResult:
            payload = {"recipient": recipient, "subject": subject, "body": body}
            self.__class__.calls.append(payload)
            return NotificationResult(success=True, message="queued")

    monkeypatch.setattr(
        NotificationViewSet,
        "notification_service_class",
        DummyNotificationService,
    )

    user = user_factory(email="notify@example.com")
    api_client.force_authenticate(user)
    response = api_client.post(reverse("api:notifications-send-test-notification"))

    assert response.status_code == 200
    assert response.json() == {"success": True, "message": "queued"}
    assert DummyNotificationService.calls == [
        {
            "recipient": user.email,
            "subject": "Test notification",
            "body": "This is a mock notification.",
        }
    ]


@pytest.mark.django_db
def test_payment_capture_updates_transaction(
    api_client, payment_transaction_factory, user_factory, monkeypatch
):
    class DummyGateway(MockPaymentGateway):
        calls: list[dict[str, object]] = []

        def __init__(self):
            self.__class__.calls.clear()

        def charge(self, *, amount: float, currency: str, metadata=None) -> PaymentResult:
            payload = {"amount": amount, "currency": currency, "metadata": metadata}
            self.__class__.calls.append(payload)
            return PaymentResult(
                reference="gateway-ref",
                status=PaymentStatus.COMPLETED,
                details={"amount": amount, "currency": currency},
            )

    monkeypatch.setattr(PaymentTransactionViewSet, "gateway_class", DummyGateway)

    payment = payment_transaction_factory()
    user = user_factory(email="payments@example.com")

    api_client.force_authenticate(user)
    response = api_client.post(reverse("api:payments-capture", args=[payment.pk]))

    assert response.status_code == 200
    data = response.json()
    payment.refresh_from_db()

    assert payment.status == "completed"
    assert payment.external_reference == "gateway-ref"
    assert data["status"] == "completed"
    assert data["external_reference"] == "gateway-ref"
    assert DummyGateway.calls == [
        {
            "amount": float(payment.amount),
            "currency": payment.currency,
            "metadata": {"reference": str(payment.pk)},
        }
    ]


@pytest.mark.django_db
def test_payment_mark_completed_and_gateway_charge(payment_transaction_factory):
    payment = payment_transaction_factory()
    gateway = MockPaymentGateway()

    result = gateway.charge(
        amount=float(payment.amount),
        currency=payment.currency,
        metadata={"reference": "ext-123"},
    )

    assert result.status == PaymentStatus.COMPLETED
    assert result.reference == "ext-123"
    assert result.details == {"amount": float(payment.amount), "currency": payment.currency}

    payment.mark_completed(result.reference)
    payment.refresh_from_db()

    assert payment.status == "completed"
    assert payment.external_reference == "ext-123"


@pytest.mark.django_db
def test_notification_mark_read_persists_timestamp(notification_factory):
    notification = notification_factory()
    assert notification.read_at is None

    notification.mark_read()
    notification.refresh_from_db()

    assert notification.read_at is not None


@pytest.mark.django_db
def test_openapi_schema_matches_snapshot(api_client, settings):
    response = api_client.get(
        reverse("schema"), HTTP_ACCEPT="application/json"
    )
    assert response.status_code == 200

    schema = response.json()
    snapshot_path = Path(settings.BASE_DIR) / "api" / "schema" / "openapi.json"
    expected = json.loads(snapshot_path.read_text())

    assert schema == expected
