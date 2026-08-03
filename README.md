# Flow App

A marketplace mobile app built with Flutter, backed by a FastAPI + MySQL service.

## Structure

```
├── lib/                  # Flutter app (Riverpod, GoRouter, freezed models)
├── backend/              # FastAPI + SQLAlchemy + MySQL API
│   ├── src/flow_app/     # Application package (api, core, models, utils)
│   ├── db/               # schema.sql, seed.sql, CSV exports
│   └── tests/            # Pytest suite
└── tool/                 # Dart smoke tests against the live API
```

## Client (Flutter)

- **State**: Riverpod (`StateNotifier` + `StateNotifierProvider`)
- **Navigation**: GoRouter with a 5-tab shell (Home, Explore, Orders, Messages, Profile)
- **Models**: freezed + json_serializable; generated files are committed
- **Data**: repositories hit the backend API (`useRemoteBackend` in `lib/core/network/api_config.dart`)

```bash
flutter pub get
flutter run -d macos     # or your target device
```

Verify before committing:

```bash
flutter analyze
flutter test
```

## API (FastAPI)

See [`backend/README.md`](backend/README.md) for setup, endpoints, and commands.

```bash
cd backend
brew services start mysql
python -m flow_app.utils.seed_db
python3 -m venv .venv && source .venv/bin/activate
pip install ".[dev]"
uvicorn flow_app.main:app --reload --port 8000
```

API docs: http://localhost:8000/docs

## Database

- Source of truth: `backend/db/schema.sql` + `backend/db/seed.sql`
- Export any table to CSV for sharing: `python -m flow_app.utils.export_csv` (outputs to `backend/db/exports/`)
