#!/usr/bin/env bash
set -euo pipefail

cd docker
docker compose down
cd ..

# Load .env if present (root of the project)
if [[ -f ".env" ]]; then
  set -a
  # shellcheck source=/dev/null
  source ".env"
  set +a
fi

echo "Starting Docker environment..."
docker compose -f docker/docker-compose.yml --env-file .env config