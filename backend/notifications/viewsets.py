"""Viewsets for notifications."""
from __future__ import annotations

from rest_framework import permissions, status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from .adapters import MockNotificationService
from .models import Notification
from .serializers import NotificationSerializer


class NotificationViewSet(viewsets.ModelViewSet):
    queryset = Notification.objects.select_related("recipient").all()
    serializer_class = NotificationSerializer
    permission_classes = [permissions.IsAuthenticated]
    notification_service_class = MockNotificationService

    def get_queryset(self):
        queryset = super().get_queryset()
        if self.request.user.is_staff:
            return queryset
        return queryset.filter(recipient=self.request.user)

    @action(detail=False, methods=["post"], url_path="send-test")
    def send_test_notification(self, request, *args, **kwargs):
        notification_service = self.notification_service_class()
        result = notification_service.send(
            recipient=request.user.email,
            subject="Test notification",
            body="This is a mock notification.",
        )
        return Response({"success": result.success, "message": result.message}, status=status.HTTP_200_OK)
