"""API test fixtures and factories for the backend suite."""

from __future__ import annotations

from datetime import timedelta
from decimal import Decimal
from uuid import uuid4

import pytest
from django.utils import timezone

from appointments.models import Appointment
from business.models import BusinessProfile
from marketplace.models import Listing
from notifications.models import Notification
from payments.models import PaymentTransaction
from services.models import Service


@pytest.fixture
def business_profile_factory(user_factory):
    """Factory for creating business profiles with unique owners."""

    def create_business_profile(**kwargs):
        owner = kwargs.pop(
            "owner", user_factory(email=f"owner-{uuid4().hex}@example.com")
        )
        defaults = {
            "name": "Test Business",
            "description": "Business description",
        }
        defaults.update(kwargs)
        return BusinessProfile.objects.create(owner=owner, **defaults)

    return create_business_profile


@pytest.fixture
def service_factory(business_profile_factory):
    """Factory for creating services tied to a business."""

    def create_service(**kwargs):
        business = kwargs.pop("business", business_profile_factory())
        defaults = {
            "name": "Consultation",
            "description": "Service description",
            "duration_minutes": 60,
        }
        defaults.update(kwargs)
        return Service.objects.create(business=business, **defaults)

    return create_service


@pytest.fixture
def appointment_factory(user_factory, service_factory):
    """Factory for creating appointments with coherent relationships."""

    def create_appointment(**kwargs):
        customer = kwargs.pop(
            "customer", user_factory(email=f"customer-{uuid4().hex}@example.com")
        )
        service = kwargs.pop("service", service_factory())
        business = kwargs.pop("business", service.business)
        defaults = {
            "scheduled_for": timezone.now() + timedelta(days=1),
            "status": "scheduled",
            "notes": "",
        }
        defaults.update(kwargs)
        return Appointment.objects.create(
            customer=customer, business=business, service=service, **defaults
        )

    return create_appointment


@pytest.fixture
def listing_factory(service_factory):
    """Factory for creating marketplace listings."""

    def create_listing(**kwargs):
        service = kwargs.pop("service", service_factory())
        business = kwargs.pop("business", service.business)
        defaults = {
            "price": Decimal("49.99"),
            "is_active": True,
        }
        defaults.update(kwargs)
        return Listing.objects.create(
            business=business, service=service, **defaults
        )

    return create_listing


@pytest.fixture
def payment_transaction_factory(appointment_factory):
    """Factory for creating payment transactions."""

    def create_payment_transaction(**kwargs):
        appointment = kwargs.pop("appointment", appointment_factory())
        defaults = {
            "amount": Decimal("100.00"),
            "currency": "USD",
            "status": "pending",
            "external_reference": "",
        }
        defaults.update(kwargs)
        return PaymentTransaction.objects.create(
            appointment=appointment, **defaults
        )

    return create_payment_transaction


@pytest.fixture
def notification_factory(user_factory):
    """Factory for creating notifications."""

    def create_notification(**kwargs):
        recipient = kwargs.pop(
            "recipient", user_factory(email=f"notify-{uuid4().hex}@example.com")
        )
        defaults = {
            "subject": "Test notification",
            "body": "This is a test notification.",
        }
        defaults.update(kwargs)
        return Notification.objects.create(recipient=recipient, **defaults)

    return create_notification
