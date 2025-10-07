# Apatie Codex

## Development Environment Bootstrap

### Docker Compose workflow

1. Copy the provided environment templates:
   ```bash
   cp .env.example .env
   cp backend/.env.example backend/.env
   cp frontend/.env.example frontend/.env
   ```
2. Build the backend image and start supporting services:
   ```bash
   docker compose -f infra/docker-compose.yml build
   docker compose -f infra/docker-compose.yml up -d db redis
   ```
3. Apply database migrations:
   ```bash
   docker compose -f infra/docker-compose.yml run --rm backend python manage.py migrate
   ```
4. Seed the development database with demo users and businesses:
   ```bash
   docker compose -f infra/docker-compose.yml run --rm backend python scripts/seed_dev.py
   ```
5. Launch the full stack (Django API, Celery worker/beat, Channels worker):
   ```bash
   docker compose -f infra/docker-compose.yml up
   ```

The API will be available at [http://localhost:8000](http://localhost:8000). PostgreSQL (port `5432`) and Redis (port `6379`) are exposed for local tooling. To stop and clean the stack run:

```bash
docker compose -f infra/docker-compose.yml down
```

Add `-v` to also drop volumes.

### Regenerating the OpenAPI schema

The schema committed at `backend/api/schema/openapi.yaml` is generated with DRF Spectacular. Update it whenever the API surface changes:

```bash
docker compose -f infra/docker-compose.yml run --rm backend python manage.py spectacular --file api/schema/openapi.yaml
```

Alternatively, run the same command from a local virtual environment (`python backend/manage.py spectacular --file backend/api/schema/openapi.yaml`).

### Manual backend setup (optional)

If you prefer running the backend without Docker:

1. Create and activate a virtual environment:
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # Windows: .venv\Scripts\activate
   ```
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Copy environment configuration and update values as needed:
   ```bash
   cp backend/.env.example backend/.env
   ```
4. Apply database migrations:
   ```bash
   python backend/manage.py migrate
   ```
5. (Optional) Seed development data:
   ```bash
   python backend/scripts/seed_dev.py
   ```
6. Create a superuser if required:
   ```bash
   python backend/manage.py createsuperuser
   ```
7. Run the development server and background workers:
   ```bash
   python backend/manage.py runserver
   celery -A core.celery worker -l info
   celery -A core.celery beat -l info
   python backend/manage.py runworker
   ```

## Backend overview

The backend is a Django project located in the `backend/` directory. It provides a modular architecture with dedicated apps for core domains such as users, business profiles, services, appointments, marketplace listings, payments, and notifications.

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

### Running tests

Use Django's test runner with the dedicated test settings module:

```bash
DJANGO_SETTINGS_MODULE=core.settings.test python backend/manage.py test
```

## Frontend (Flutter) Setup

The Flutter client lives in `frontend/flutter_app/` and targets Flutter 3.x with sound null safety. The app is organised into feature modules (`appointments`, `marketplace`, `services`) and separates responsibilities into `data`, `domain`, and `ui` layers.

### Prerequisites

* Flutter SDK 3.x (`flutter --version` should report a 3.x release)
* Dart SDK that ships with Flutter

### Install dependencies and generate localization code

```bash
cd frontend/flutter_app
flutter pub get
flutter gen-l10n
```

### Run static analysis and tests

```bash
cd frontend/flutter_app
flutter analyze
flutter test
```

The widget tests include coverage for the tabbed navigation scaffolded with GoRouter, and unit tests ensure the hydrated theme cubit behaves as expected.

### Code Quality

This repository provides foundational stubs for serializers, viewsets, and integrations (payments, notifications). Extend these stubs with real implementations as business requirements evolve. The logging configuration includes an `apatie.audit` logger to support future audit trails.
