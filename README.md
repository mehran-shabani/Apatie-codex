# Apatie Codex

[![Backend CI](https://github.com/OWNER/Apatie-codex/actions/workflows/backend.yml/badge.svg)](https://github.com/OWNER/Apatie-codex/actions/workflows/backend.yml)
[![Frontend CI](https://github.com/OWNER/Apatie-codex/actions/workflows/frontend.yml/badge.svg)](https://github.com/OWNER/Apatie-codex/actions/workflows/frontend.yml)
[![Infrastructure Checks](https://github.com/OWNER/Apatie-codex/actions/workflows/infra.yml/badge.svg)](https://github.com/OWNER/Apatie-codex/actions/workflows/infra.yml)

> Replace `OWNER` with the GitHub organisation or username that hosts this repository to render live status badges.

## Development Environment Bootstrap

## Contributing

We encourage contributors to review our [issue templates](.github/ISSUE_TEMPLATE/) and [pull request template](.github/pull_request_template.md) before opening a ticket or submitting code. Bug reports and feature proposals should include clear summaries, reproduction steps or problem statements, expected outcomes, relevant screenshots, and acceptance criteria to help maintainers respond quickly. Pull requests should document the change summary, testing evidence, release note impact, and any deployment considerations so reviewers can merge with confidence.

### Automated releases

Releases are managed by [Release Please](https://github.com/google-github-actions/release-please-action) via the `Release Automation` workflow. When a pull request targeting the default `main` branch is merged, the workflow analyzes commit messages and prepares a release pull request that bumps versions, updates changelogs, and tags the repository when merged. Contributors must:

* Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for every commit included in the release so Release Please can determine semantic version updates.
* Avoid removing the `autorelease: pending` label from Release Please pull requests—this label is required for the automation to finalize the release.

Once a release is published, the workflow automatically builds and pushes Docker images to the GitHub Container Registry (GHCR) using the release tag and uploads a companion changelog asset to the GitHub Release page. Ensure any required registry secrets (for example, additional credentials beyond `${{ secrets.GITHUB_TOKEN }}`) are configured in the repository settings before publishing.

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

### Pre-commit hooks

Automate formatting, linting, and migration checks with [pre-commit](https://pre-commit.com/). The configured hooks run Black,
isort, Flake8, and Pylint for the Django backend, enforce `flutter format`/`flutter analyze` for the client, and ensure
migrations are kept in sync:

```bash
pip install pre-commit
pre-commit install
```

Run all hooks locally before pushing changes:

```bash
pre-commit run --all-files
```

## Backend overview

The backend is a Django project located in the `backend/` directory. It provides a modular architecture with dedicated apps for core domains such as users, business profiles, services, appointments, marketplace listings, payments, and notifications.

### API & Tooling

* REST API endpoints are namespaced under `/api/v1/`.
* JWT authentication endpoints are available at `/api/auth/jwt/create/` and `/api/auth/jwt/refresh/`.
* API schema documentation is served via:
  * `/api/schema/` for the OpenAPI schema (JSON)
  * `/api/docs/` for Swagger UI
* A health check endpoint is exposed at `/healthz`.

### Environment Variables

All configurable settings are documented in `backend/.env.example`. The project uses [`django-environ`](https://django-environ.readthedocs.io/) to load variables from the `.env` file.

### Running tests

#### Backend (pytest)

Run the Python test suite from the repository root. The provided `pytest.ini` automatically configures the Django settings module and Python path.

```bash
pytest
```

#### Frontend (Flutter)

Execute the Flutter widget and unit tests from the app directory:

```bash
cd frontend/flutter_app
flutter test
```

### Design system golden tests

Golden coverage for the design system lives under [`frontend/flutter_app/test/design_system/`](frontend/flutter_app/test/design_system/). Contributors must:

* Keep the documentation in [`test/design_system/README.md`](frontend/flutter_app/test/design_system/README.md) handy for prerequisites, local commands, and troubleshooting guidance.
* Run `flutter test` before every pull request to ensure no regressions slip through. The [Frontend CI workflow](.github/workflows/frontend.yml) executes the same command and will fail the build on any missing assets or unexpected golden diffs.
* When intentional visual changes occur, regenerate the baselines with `flutter test --update-goldens`, review the PNGs inside [`test/design_system/goldens/`](frontend/flutter_app/test/design_system/goldens/), and commit the updated assets alongside the code.
* Resolve failing CI snapshots by either updating the baselines (for expected changes) or fixing the widgets (for unintended regressions) before requesting a review.

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
