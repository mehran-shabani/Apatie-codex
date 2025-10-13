"""Generic, auto-configured viewsets for public API resources."""

from __future__ import annotations

from collections.abc import Sequence
from typing import ClassVar, TypeVar

from django.core.exceptions import ImproperlyConfigured
from django.db import models
from django_filters import rest_framework as django_filters
from rest_framework import filters as drf_filters
from rest_framework import permissions, status, viewsets
from rest_framework.decorators import action
from rest_framework.request import Request
from rest_framework.response import Response

from api.filters import build_filterset_for_model
from api.pagination import DefaultPagination
from api.serializers import build_model_serializer
from appointments.models import Appointment
from business.models import BusinessProfile
from marketplace.models import Listing
from notifications.adapters import MockNotificationService
from notifications.models import Notification
from payments.adapters import MockPaymentGateway
from payments.models import PaymentTransaction
from services.models import Service
from users.models import User

ModelT = TypeVar("ModelT", bound=models.Model)

__all__ = [
    "AutoModelViewSet",
    "UserViewSet",
    "BusinessProfileViewSet",
    "ServiceViewSet",
    "ListingViewSet",
    "AppointmentViewSet",
    "PaymentTransactionViewSet",
    "NotificationViewSet",
]


class AutoModelViewSet(viewsets.ModelViewSet):
    """Base class that auto-wires serializer, filterset and pagination."""

    model: ClassVar[type[ModelT] | None] = None
    serializer_fields: ClassVar[Sequence[str] | None] = None
    serializer_read_only_fields: ClassVar[Sequence[str] | None] = None
    filterset_fields: ClassVar[Sequence[str] | None | bool] = None
    select_related: ClassVar[Sequence[str]] = ()
    prefetch_related: ClassVar[Sequence[str]] = ()

    pagination_class = DefaultPagination
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = (
        django_filters.DjangoFilterBackend,
        drf_filters.SearchFilter,
        drf_filters.OrderingFilter,
    )
    ordering_fields = "__all__"

    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        model = getattr(cls, "model", None)
        if model is None:
            return

        serializer_fields = getattr(cls, "serializer_fields", None)
        default_read_only = cls._default_read_only_fields_for_model(model)
        extra_read_only = getattr(cls, "serializer_read_only_fields", None)
        if extra_read_only:
            read_only = tuple(sorted({*default_read_only, *extra_read_only}))
        else:
            read_only = default_read_only

        if getattr(cls, "serializer_class", None) is None:
            cls.serializer_class = build_model_serializer(
                model, fields=serializer_fields, read_only_fields=read_only
            )

        filterset_fields = getattr(cls, "filterset_fields", None)
        if getattr(cls, "filterset_class", None) is None and filterset_fields is not False:
            candidate_fields: Sequence[str] | None
            if isinstance(filterset_fields, Sequence):
                candidate_fields = filterset_fields
            elif serializer_fields is not None:
                candidate_fields = serializer_fields
            else:
                candidate_fields = None
            cls.filterset_class = build_filterset_for_model(
                model, fields=candidate_fields
            )

    @staticmethod
    def _default_read_only_fields_for_model(model: type[models.Model]) -> Sequence[str]:
        fields: set[str] = set()
        pk = model._meta.pk
        if pk is not None:
            fields.add(pk.name)
        for field in model._meta.get_fields():
            if getattr(field, "auto_now", False) or getattr(field, "auto_now_add", False):
                fields.add(field.name)
        return tuple(sorted(fields))

    def get_queryset(self):  # type: ignore[override]
        model = getattr(self, "model", None)
        if model is None:
            raise ImproperlyConfigured("AutoModelViewSet subclasses must define a model")

        queryset = model._default_manager.all()
        if self.select_related:
            queryset = queryset.select_related(*self.select_related)
        if self.prefetch_related:
            queryset = queryset.prefetch_related(*self.prefetch_related)

        ordering = getattr(self, "ordering", None)
        if ordering:
            queryset = queryset.order_by(*ordering)
        elif model._meta.ordering:
            queryset = queryset.order_by(*model._meta.ordering)

        return queryset


class UserViewSet(AutoModelViewSet):
    """Viewset for user accounts."""

    model = User
    serializer_fields = (
        "id",
        "email",
        "full_name",
        "is_active",
        "created_at",
        "updated_at",
    )
    serializer_read_only_fields = ("is_active",)
    search_fields = ("email", "full_name")


class BusinessProfileViewSet(AutoModelViewSet):
    """Viewset for business profiles."""

    model = BusinessProfile
    serializer_fields = (
        "id",
        "owner",
        "name",
        "description",
        "created_at",
        "updated_at",
    )
    serializer_read_only_fields = ("owner",)
    select_related = ("owner",)
    search_fields = ("name", "description", "owner__email")

    def perform_create(self, serializer):  # type: ignore[override]
        serializer.save(owner=self.request.user)


class ServiceViewSet(AutoModelViewSet):
    """Viewset for services offered by businesses."""

    model = Service
    serializer_fields = (
        "id",
        "business",
        "name",
        "description",
        "duration_minutes",
        "created_at",
        "updated_at",
    )
    select_related = ("business",)
    search_fields = ("name", "description", "business__name")

    def get_queryset(self):  # type: ignore[override]
        queryset = super().get_queryset()
        user = self.request.user
        if getattr(user, "is_staff", False):
            return queryset
        return queryset.filter(business__owner=user)


class ListingViewSet(AutoModelViewSet):
    """Viewset for marketplace listings."""

    model = Listing
    serializer_fields = (
        "id",
        "business",
        "service",
        "price",
        "is_active",
        "created_at",
        "updated_at",
    )
    select_related = ("business", "service")
    search_fields = (
        "service__name",
        "business__name",
    )

    def get_queryset(self):  # type: ignore[override]
        queryset = super().get_queryset()
        user = self.request.user
        if getattr(user, "is_staff", False):
            return queryset
        return queryset.filter(business__owner=user)


class AppointmentViewSet(AutoModelViewSet):
    """Viewset for appointments."""

    model = Appointment
    serializer_fields = (
        "id",
        "customer",
        "business",
        "service",
        "scheduled_for",
        "status",
        "notes",
        "created_at",
        "updated_at",
    )
    select_related = ("customer", "business", "service")
    search_fields = ("customer__email", "status", "business__name", "service__name")

    def get_queryset(self):  # type: ignore[override]
        queryset = super().get_queryset()
        user = self.request.user
        if getattr(user, "is_staff", False):
            return queryset
        return queryset.filter(customer=user)


class PaymentTransactionViewSet(AutoModelViewSet):
    """Viewset for payment transactions."""

    model = PaymentTransaction
    serializer_fields = (
        "id",
        "appointment",
        "amount",
        "currency",
        "status",
        "external_reference",
        "created_at",
        "updated_at",
    )
    serializer_read_only_fields = ("status", "external_reference")
    select_related = ("appointment",)
    search_fields = ("status", "currency", "appointment__customer__email")
    gateway_class = MockPaymentGateway

    def perform_create(self, serializer):  # type: ignore[override]
        serializer.save(status="pending")

    @action(detail=True, methods=["post"], url_path="capture")
    def capture(self, request: Request, *args, **kwargs):
        payment = self.get_object()
        gateway = self.gateway_class()
        result = gateway.charge(
            amount=payment.amount,
            currency=payment.currency,
            metadata={"reference": str(payment.pk)},
        )
        payment.mark_completed(result.reference)
        serializer = self.get_serializer(payment)
        return Response(serializer.data, status=status.HTTP_200_OK)


class NotificationViewSet(AutoModelViewSet):
    """Viewset for user notifications."""

    model = Notification
    serializer_fields = (
        "id",
        "recipient",
        "subject",
        "body",
        "read_at",
        "created_at",
        "updated_at",
    )
    serializer_read_only_fields = ("read_at",)
    select_related = ("recipient",)
    search_fields = ("subject", "body", "recipient__email")
    notification_service_class = MockNotificationService

    def get_queryset(self):  # type: ignore[override]
        queryset = super().get_queryset()
        user = self.request.user
        if getattr(user, "is_staff", False):
            return queryset
        return queryset.filter(recipient=user)

    @action(detail=False, methods=["post"], url_path="send-test")
    def send_test_notification(self, request: Request, *args, **kwargs):
        notification_service = self.notification_service_class()
        result = notification_service.send(
            recipient=request.user.email,
            subject="Test notification",
            body="This is a mock notification.",
        )
        return Response(
            {"success": result.success, "message": result.message},
            status=status.HTTP_200_OK,
        )
