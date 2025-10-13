"""Utilities for dynamically constructing DRF serializers."""

from __future__ import annotations

from collections.abc import Iterable
from typing import Sequence

from django.db import models
from rest_framework import serializers

__all__ = ["build_model_serializer"]


def _resolve_serializer_fields(
    model: type[models.Model], fields: Iterable[str] | None
) -> Sequence[str]:
    if fields is not None:
        return tuple(dict.fromkeys(fields))

    resolved: list[str] = []
    for field in model._meta.get_fields():
        if getattr(field, "auto_created", False) and not getattr(field, "concrete", False):
            continue
        if getattr(field, "concrete", False) or getattr(field, "many_to_many", False):
            resolved.append(field.name)
    return tuple(dict.fromkeys(resolved))


def build_model_serializer(
    model: type[models.Model],
    *,
    fields: Iterable[str] | None = None,
    read_only_fields: Iterable[str] | None = None,
) -> type[serializers.ModelSerializer]:
    """Create a ``ModelSerializer`` subclass for ``model``."""

    resolved_fields = _resolve_serializer_fields(model, fields)
    read_only = tuple(dict.fromkeys(read_only_fields or ()))

    meta_attrs: dict[str, object] = {"model": model, "fields": resolved_fields}
    if read_only:
        meta_attrs["read_only_fields"] = read_only

    meta = type("Meta", (), meta_attrs)
    serializer_name = f"{model.__name__}AutoSerializer"

    return type(serializer_name, (serializers.ModelSerializer,), {"Meta": meta})
