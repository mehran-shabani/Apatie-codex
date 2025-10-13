"""Common viewset utilities."""

from rest_framework import mixins, viewsets


class ReadOnlyModelViewSet(
    mixins.ListModelMixin, mixins.RetrieveModelMixin, viewsets.GenericViewSet
):
    """Shared read-only base viewset."""

    pass
