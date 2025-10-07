# SuperApp Monorepo Scaffold

This repository bootstraps a Flutter + Django "super app" ready to host three core experiences:

- **Appointments** scheduling
- **Marketplace** for homemade products
- **On-demand services**

## Structure

```
backend/            # Django + DRF project code
frontend/flutter_app# Flutter application
infra/              # Infrastructure as code
```

## Getting Started

1. Copy `.env.example` to `.env` and review the values.
2. Build infrastructure services:
   ```bash
   docker-compose -f infra/docker-compose.yml up -d
   ```
3. Set up the backend:
   ```bash
   cd backend
   python -m venv .venv && source .venv/bin/activate
   pip install -r requirements.txt
   python manage.py migrate
   python manage.py createsuperuser
   python manage.py runserver
   ```
4. Run the Flutter app:
   ```bash
   cd frontend/flutter_app
   flutter pub get
   flutter run
   ```

## Development Notes

- Assumes local Postgres port `5432` and Redis `6379`.
- External integrations (payments, notifications) use adapter stubs until providers are selected.
- API is namespaced under `/api/v1/` with automatic OpenAPI schema generation.
- See `.github/workflows/ci.yml` for automated linting and tests.

