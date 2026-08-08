#!/bin/sh
# Docker entrypoint: wait for the database, then run the container command.
set -e

python docker_wait.py
exec "$@"
