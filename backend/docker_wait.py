"""Wait for the MySQL database before uvicorn starts.

Standalone script for the Docker entrypoint. Polls the database from the
FLOW_DATABASE_URL connection string until it accepts connections.
"""
import os
import sys
import time

import pymysql


def _parse_database_url(url: str) -> tuple[str, int, str, str, str]:
    rest = url[len("mysql+pymysql://"):]
    creds, _, hostpart = rest.rpartition("@")
    user, _, password = creds.partition(":")
    hostport, _, dbname = hostpart.partition("/")
    host, _, port = hostport.partition(":")
    return host, int(port or 3306), user, password, dbname


def wait_for_db(url: str, max_attempts: int = 60, delay: float = 2.0) -> None:
    host, port, user, password, dbname = _parse_database_url(url)
    for attempt in range(1, max_attempts + 1):
        try:
            conn = pymysql.connect(
                host=host,
                port=port,
                user=user,
                password=password,
                database=dbname,
                connect_timeout=5,
            )
            conn.close()
            print("Database is ready.")
            return
        except Exception as exc:  # noqa: BLE001
            if attempt % 5 == 0 or attempt == max_attempts:
                sys.stderr.write(
                    f"Database not ready (attempt {attempt}/{max_attempts}): {exc}\n"
                )
            time.sleep(delay)
    sys.exit(1)


if __name__ == "__main__":
    url = os.environ.get("FLOW_DATABASE_URL", "")
    if not url.startswith("mysql+pymysql://"):
        sys.stderr.write("FLOW_DATABASE_URL is not a pymysql URL; skipping DB wait.\n")
        sys.exit(0)
    wait_for_db(url)
