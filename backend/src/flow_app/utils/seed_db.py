#!/usr/bin/env python3
"""Recreate the flow_app database and apply schema + seed.

Usage (from backend/):
    python -m flow_app.utils.seed_db
"""
import os
import pathlib
import subprocess

ROOT = pathlib.Path(os.environ.get("FLOW_PROJECT_ROOT", pathlib.Path.cwd()))
SCHEMA = ROOT / "db" / "schema.sql"
SEED = ROOT / "db" / "seed.sql"

MYSQL_USER = "root"
DB_NAME = "flow_app"
APP_USER = "flow_app"
APP_PASSWORD = "flow_dev_password"


def run_script(args: list[str], script: pathlib.Path) -> None:
    result = subprocess.run(
        args,
        input=script.read_text(encoding="utf-8"),
        text=True,
        capture_output=True,
    )
    if result.returncode != 0:
        raise SystemExit(result.stderr)
    print(f"Applied {script.name}")


def main() -> None:
    subprocess.run(
        ["mysql", f"-u{MYSQL_USER}", "-e",
         f"DROP DATABASE IF EXISTS {DB_NAME}; "
         f"CREATE DATABASE {DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"],
        check=True,
    )
    subprocess.run(
        ["mysql", f"-u{MYSQL_USER}", "-e",
         f"CREATE USER IF NOT EXISTS '{APP_USER}'@'localhost' IDENTIFIED BY '{APP_PASSWORD}'; "
         f"GRANT ALL PRIVILEGES ON {DB_NAME}.* TO '{APP_USER}'@'localhost'; "
         "FLUSH PRIVILEGES;"],
        check=True,
    )
    run_script(["mysql", f"-u{MYSQL_USER}", DB_NAME], SCHEMA)
    run_script(["mysql", f"-u{MYSQL_USER}", DB_NAME], SEED)
    print(f"Database '{DB_NAME}' recreated and seeded.")


if __name__ == "__main__":
    main()
