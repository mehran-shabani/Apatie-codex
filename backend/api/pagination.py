"""Pagination utilities for the public API."""

from __future__ import annotations

from rest_framework.pagination import PageNumberPagination

__all__ = ["DefaultPagination"]


class DefaultPagination(PageNumberPagination):
    """Consistent page-number pagination for API endpoints."""

    page_size = 10
    page_size_query_param = "page_size"
    max_page_size = 100
