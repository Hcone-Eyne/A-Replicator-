# Flow App Backend

FastAPI + SQLAlchemy + MySQL backend serving the Flow marketplace Flutter app.

## Stack

- Python 3.12+, FastAPI, SQLAlchemy 2.0, PyMySQL
- MySQL 9.x (Homebrew): database `flow_app`, user `flow_app` / `flow_dev_password`

## Project layout

```
backend/
├── src/flow_app/        # Application package (src layout)
│   ├── main.py          # FastAPI app entry point
│   ├── config.py        # Settings (FLOW_* env vars)
│   ├── api/             # Routes, schemas, serializers
│   ├── core/            # Database engine + shared services
│   ├── models/          # SQLAlchemy ORM models
│   └── utils/           # seed_db, export_csv helpers
├── tests/               # Pytest suite
├── db/                  # schema.sql, seed.sql, exports/
├── docs/                # Project docs
├── Dockerfile
└── pyproject.toml       # Build, metadata, dependencies
```

## Setup

```bash
# 1. Start MySQL (Homebrew)
brew services start mysql

# 2. Create DB + schema + seed (tables in db/*.sql are source of truth)
python -m flow_app.utils.seed_db

# 3. Virtualenv + deps (install from pyproject.toml)
python3 -m venv .venv
source .venv/bin/activate
pip install ".[dev]"

# 4. Config
cp .env.example .env   # adjust if needed

# 5. Run
uvicorn flow_app.main:app --reload --port 4000
```

API docs: http://localhost:4000/docs

## Commands

```bash
python -m flow_app.utils.seed_db        # recreate + seed the database
python -m flow_app.utils.export_csv     # export all tables to db/exports/*.csv
pytest                                  # run the test suite
```

## Endpoints

- `GET  /auth/me` · `POST /auth/login` · `POST /auth/register` · `POST /auth/otp/send|verify` · `POST /auth/reset-password`
- `GET  /listings?page&limit&category&sortBy` · `GET /listings/search?q` · `GET/POST/PUT/DELETE /listings[/{id}]` · `POST /listings/{id}/favorite`
- `GET  /categories`
- `GET/PUT /profile` · `GET /sellers/{id}` · `POST/DELETE /sellers/{id}/follow` · `GET /sellers/{id}/reviews`
- `GET  /orders?status` · `GET /orders/{id}` · `POST /orders/{id}/cancel` · `GET /orders/{id}/track`
- `GET  /conversations` · `GET/POST /conversations/{id}/messages` · `POST /conversations/{id}/read` · `GET /conversations/unread-count`
- `GET  /notifications` · `POST /notifications/{id}/read` · `POST /notifications/read-all` · `GET /notifications/unread-count`

## Notes

- Response JSON keys match the Dart freezed models exactly (camelCase, ISO-8601 datetimes).
- No auth tokens yet (planned). The "current user" defaults to `user_001` (`FLOW_CURRENT_USER_ID`).
- Flutter app base URL: `http://localhost:4000` (Android emulator: `http://10.0.2.2:4000`).
