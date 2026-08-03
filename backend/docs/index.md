# Flow App Backend Docs

FastAPI + SQLAlchemy + MySQL backend serving the Flow marketplace app.

## Architecture

```
src/flow_app/
├── main.py            # FastAPI app factory, CORS, router registration
├── config.py          # Settings via FLOW_* env vars (pydantic-settings)
├── api/
│   ├── schemas.py     # Pydantic request/response models
│   ├── serializers.py # DB rows -> Dart-compatible JSON payloads
│   └── routers/       # HTTP route modules (auth, listings, ...)
├── core/
│   ├── database.py    # SQLAlchemy engine, session, Base
│   └── services.py    # Shared query helpers
├── models/            # SQLAlchemy ORM models (mirror db/schema.sql)
└── utils/
    ├── seed_db.py     # Recreates DB from db/schema.sql + seed.sql
    └── export_csv.py  # Exports all tables to backend/db/exports/
```

Schema source of truth: `db/schema.sql`. Seeds: `db/seed.sql`.

## API contract

Response JSON keys match the Flutter freezed models exactly
(camelCase keys, ISO-8601 datetimes). OpenAPI docs at `/docs`.
