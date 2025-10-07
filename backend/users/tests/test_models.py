import pytest
from django.contrib.auth import get_user_model


User = get_user_model()


@pytest.mark.django_db
def test_create_user_with_email():
    user = User.objects.create_user(email="user@example.com", password="pass1234", full_name="Test User")
    assert user.email == "user@example.com"
    assert user.check_password("pass1234")
    assert not user.is_staff


@pytest.mark.django_db
def test_create_superuser():
    admin = User.objects.create_superuser(email="admin@example.com", password="pass1234")
    assert admin.is_staff
    assert admin.is_superuser
