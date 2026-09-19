#!/usr/bin/env bash
set -euo pipefail

# Load .env if present (root of the project)
if [[ -f ".env" ]]; then
  set -a
  # shellcheck source=/dev/null
  source ".env"
  set +a
fi

echo "Starting Docker environment..."
cd docker
docker compose up --build