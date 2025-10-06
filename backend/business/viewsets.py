"""Viewsets for business resources."""
from __future__ import annotations

from rest_framework import permissions, viewsets

from .models import BusinessProfile
from .serializers import BusinessProfileSerializer


class BusinessProfileViewSet(viewsets.ModelViewSet):
    queryset = BusinessProfile.objects.select_related("owner").all()
    serializer_class = BusinessProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)
