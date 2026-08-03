#!/usr/bin/env python3
"""Export all flow_app tables to CSV files (with headers) for sharing.

Usage (from backend/):
    python -m flow_app.utils.export_csv
"""
import csv
import os
import pathlib
import pymysql

DB_CONFIG = {
    "host": "localhost",
    "port": 3306,
    "user": "flow_app",
    "password": "flow_dev_password",
    "database": "flow_app",
    "charset": "utf8mb4",
    "cursorclass": pymysql.cursors.DictCursor,
}

TABLES = [
    "flow_users",
    "flow_user_follows",
    "flow_categories",
    "flow_listings",
    "flow_favorites",
    "flow_orders",
    "flow_conversations",
    "flow_messages",
    "flow_reviews",
    "flow_notifications",
]

OUTPUT_DIR = (
    pathlib.Path(os.environ.get("FLOW_PROJECT_ROOT", pathlib.Path.cwd())) / "db" / "exports"
)


def table_has_id(conn, table: str) -> bool:
    with conn.cursor() as cur:
        cur.execute(
            "SELECT COUNT(*) AS n FROM information_schema.columns "
            "WHERE table_schema = %s AND table_name = %s AND column_name = 'id'",
            ("flow_app", table),
        )
        return cur.fetchone()["n"] > 0


def export_table(conn, table: str) -> int:
    order_by = " ORDER BY id" if table_has_id(conn, table) else ""
    with conn.cursor() as cur:
        cur.execute(f"SELECT * FROM `{table}`{order_by}")
        rows = cur.fetchall()

    if not rows:
        return 0

    output = OUTPUT_DIR / f"{table}.csv"
    with output.open("w", newline="", encoding="utf-8-sig") as fh:
        writer = csv.DictWriter(fh, fieldnames=list(rows[0].keys()), restval="")
        writer.writeheader()
        for row in rows:
            cleaned = {k: ("" if v is None else v) for k, v in row.items()}
            writer.writerow(cleaned)
    return len(rows)


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    conn = pymysql.connect(**DB_CONFIG)
    try:
        total = 0
        for table in TABLES:
            count = export_table(conn, table)
            total += count
            print(f"{table:20s} -> {count:3d} rows  ({OUTPUT_DIR / (table + '.csv')})")
        print(f"\nExported {len(TABLES)} tables, {total} rows total to {OUTPUT_DIR}")
    finally:
        conn.close()


if __name__ == "__main__":
    main()
