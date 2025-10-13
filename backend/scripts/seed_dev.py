"""Populate development data for local environments."""

from __future__ import annotations

import os

import django
from django.contrib.auth import get_user_model
from django.db import transaction

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings.dev")
django.setup()

from business.models import (
    BusinessProfile,
)  # pylint: disable=wrong-import-position

User = get_user_model()


def create_user(
    email: str,
    password: str,
    full_name: str,
    *,
    is_staff: bool = False,
    is_superuser: bool = False,
) -> User:
    """Create or update a user with sensible defaults."""
    user, created = User.objects.get_or_create(
        email=email,
        defaults={
            "full_name": full_name,
            "is_staff": is_staff,
            "is_superuser": is_superuser,
        },
    )
    if created or not user.has_usable_password():
        user.set_password(password)
        user.save(update_fields=["password"])
    elif user.full_name != full_name:
        user.full_name = full_name
        user.save(update_fields=["full_name"])
    return user


def create_business(owner: User, name: str, description: str) -> BusinessProfile:
    business, _ = BusinessProfile.objects.get_or_create(
        owner=owner,
        name=name,
        defaults={"description": description},
    )
    if business.description != description:
        business.description = description
        business.save(update_fields=["description"])
    return business


def seed() -> None:
    with transaction.atomic():
        _admin = create_user(
            "admin@apatie.test",
            "adminpass",
            "Apatie Admin",
            is_staff=True,
            is_superuser=True,
        )

        owner = create_user(
            "owner@apatie.test",
            "ownerpass",
            "Olivia Owner",
        )

        _member = create_user(
            "member@apatie.test",
            "memberpass",
            "Marco Member",
        )

        create_business(
            owner=owner,
            name="Olivia's Wellness Studio",
            description="Holistic wellness consultations and personalised treatment plans.",
        )

        create_business(
            owner=owner,
            name="Downtown Therapy Loft",
            description="Boutique therapy sessions with a focus on work-life balance coaching.",
        )

    print("Seed data applied successfully.")


if __name__ == "__main__":
    seed()
