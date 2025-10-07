"""Simple development seed script."""
from django.contrib.auth import get_user_model


def run():  # pragma: no cover
    User = get_user_model()
    if not User.objects.filter(email="dev@example.com").exists():
        User.objects.create_superuser(email="dev@example.com", password="password123")
        print("Created dev@example.com")
    else:
        print("Dev user already exists")
