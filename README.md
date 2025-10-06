# Apatie Codex

## Backend Development Setup

The backend is a Django project located in the `backend/` directory. It provides a modular architecture with dedicated apps for core domains such as users, business profiles, services, appointments, marketplace listings, payments, and notifications.

### Prerequisites

* Python 3.11+
* PostgreSQL 14+
* Redis 6+
* (Optional) Node.js 18+ for frontend development

### Initial Setup

1. Create and activate a virtual environment:
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # Windows: .venv\\Scripts\\activate
   ```
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Copy the example environment file and update values as needed:
   ```bash
   cp backend/.env.example backend/.env
   ```
4. Apply database migrations:
   ```bash
   python backend/manage.py migrate
   ```
5. Create a superuser (optional but recommended):
   ```bash
   python backend/manage.py createsuperuser
   ```
6. Run the development server and background workers:
   ```bash
   # Start the Django application
   python backend/manage.py runserver

   # Start Celery worker (in a separate terminal)
   celery -A core.celery worker -l info

   # Start Channels development server (already served via runserver)
   ```

### API & Tooling

* REST API endpoints are namespaced under `/api/v1/`.
* JWT authentication endpoints are available at `/api/v1/token/` and `/api/v1/token/refresh/`.
* API schema documentation is served via:
  * `/api/schema/` for the OpenAPI schema (JSON)
  * `/api/schema/swagger/` for Swagger UI
  * `/api/schema/redoc/` for ReDoc
* A health check endpoint is exposed at `/healthz`.

### Environment Variables

All configurable settings are documented in `backend/.env.example`. The project uses [`django-environ`](https://django-environ.readthedocs.io/) to load variables from the `.env` file.

### Running Tests

Use Django's test runner with the dedicated test settings module:

```bash
DJANGO_SETTINGS_MODULE=core.settings.test python backend/manage.py test
```

### Code Quality

This repository provides foundational stubs for serializers, viewsets, and integrations (payments, notifications). Extend these stubs with real implementations as business requirements evolve. The logging configuration includes an `apatie.audit` logger to support future audit trails.
