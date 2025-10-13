"""Viewsets for payment resources."""

from __future__ import annotations

from rest_framework import permissions, status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from .adapters import MockPaymentGateway
from .models import PaymentTransaction
from .serializers import PaymentTransactionSerializer


class PaymentTransactionViewSet(viewsets.ModelViewSet):
    queryset = PaymentTransaction.objects.select_related("appointment").all()
    serializer_class = PaymentTransactionSerializer
    permission_classes = [permissions.IsAuthenticated]
    gateway_class = MockPaymentGateway

    def perform_create(self, serializer):
        serializer.save(status="pending")

    @action(detail=True, methods=["post"], url_path="capture")
    def capture(self, request, *args, **kwargs):
        payment = self.get_object()
        gateway = self.gateway_class()
        result = gateway.charge(
            amount=float(payment.amount),
            currency=payment.currency,
            metadata={"reference": str(payment.pk)},
        )
        payment.mark_completed(result.reference)
        serializer = self.get_serializer(payment)
        return Response(serializer.data, status=status.HTTP_200_OK)
