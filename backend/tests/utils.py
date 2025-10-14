"""Shared utilities for backend test suites."""

from __future__ import annotations

from collections.abc import Mapping
from typing import Any


def extract_results(payload: Any):
    """Return the result list from paginated API responses.

    The API returns paginated responses as dictionaries containing a
    ``results`` key. Non-paginated responses return a list directly. This
    helper normalises the shape across both cases for test assertions.
    """

    if isinstance(payload, Mapping) and "results" in payload:
        return payload["results"]
    return payload
