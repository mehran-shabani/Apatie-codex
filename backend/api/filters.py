"""Dynamic filterset factories for model-backed endpoints."""

from __future__ import annotations

from collections.abc import Iterable
from typing import Sequence

from django.db import models
from django_filters import rest_framework as filters

__all__ = ["build_filterset_for_model"]


def _resolve_filter_fields(model: type[models.Model], fields: Iterable[str] | None) -> Sequence[str]:
    if fields is not None:
        return tuple(dict.fromkeys(fields))

    resolved: list[str] = []
    for field in model._meta.get_fields():
        if getattr(field, "auto_created", False) and not getattr(field, "concrete", False):
            continue
        if getattr(field, "many_to_many", False) and getattr(field, "auto_created", False):
            continue
        if not getattr(field, "concrete", False) and not getattr(field, "many_to_many", False):
            continue
        resolved.append(field.name)
    return tuple(dict.fromkeys(resolved))


def build_filterset_for_model(
    model: type[models.Model], *, fields: Iterable[str] | None = None
) -> type[filters.FilterSet]:
    """Return a ``FilterSet`` subclass configured for the given model."""

    resolved_fields = _resolve_filter_fields(model, fields)

    meta_attrs: dict[str, object] = {"model": model, "fields": resolved_fields}
    meta = type("Meta", (), meta_attrs)

    filterset_name = f"{model.__name__}AutoFilterSet"
    return type(filterset_name, (filters.FilterSet,), {"Meta": meta})
