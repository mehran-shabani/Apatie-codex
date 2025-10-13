#!/usr/bin/env python
import os
import sys


def main():
    """Run administrative tasks."""

    if "DJANGO_SETTINGS_MODULE" in os.environ:
        default_settings = os.environ["DJANGO_SETTINGS_MODULE"]
    else:
        # Default to the developer settings but prefer hardened production
        # settings when running security checks such as
        # ``python manage.py check --deploy``.
        default_settings = "core.settings.dev"
        command_args = set(sys.argv[1:])
        if "check" in command_args and "--deploy" in command_args:
            default_settings = "core.settings.prod"

    os.environ.setdefault("DJANGO_SETTINGS_MODULE", default_settings)
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and available on your PYTHONPATH environment variable? Did you forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)


if __name__ == "__main__":
    main()
