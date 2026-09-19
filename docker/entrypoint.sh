#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------
# Load .env if it exists (this allows running the script directly on the
# host without having to export variables manually).  We use "set -a" so
# that all variables defined in the file become exported environment variables.
# ------------------------------------------------------------------
if [[ -f ".env" ]]; then
  set -a
  # shellcheck source=/dev/null
  source ".env"
  set +a
fi

# ------------------------------------------------------------------
# Required environment variables (provided via .env or already exported)
# ------------------------------------------------------------------
if [[ -z "${GIT_REPO:-}" ]]; then
  echo "Error: GIT_REPO is not set. Please define it in .env or export it before running entrypoint.sh" >&2
  exit 1
fi

GIT_BRANCH="${GIT_BRANCH:-main}"
# If PROJECT_NAME is not supplied, derive it from the repo URL (strip .git suffix)
PROJECT_NAME="${PROJECT_NAME:-$(basename -s .git \"$GIT_REPO\")}"

# Optional GPU restriction
if [[ -n "${GPU_IDS:-}" ]]; then
  export CUDA_VISIBLE_DEVICES="${GPU_IDS}"
fi

# ------------------------------------------------------------------
# Clone or update the repository
# ------------------------------------------------------------------
if [[ -d "${PROJECT_NAME}/.git" ]]; then
  echo "Repository already present – pulling latest changes..."
  cd "${PROJECT_NAME}"
  git fetch --all
  git checkout "${GIT_BRANCH}"
  git pull origin "${GIT_BRANCH}"
else
  echo "Cloning ${GIT_REPO} (branch ${GIT_BRANCH}) into ${PROJECT_NAME}"
  git clone --depth 1 --branch "${GIT_BRANCH}" "${GIT_REPO}" "${PROJECT_NAME}"
fi

# ------------------------------------------------------------------
# Create a venv with Python 3.12 and install dependencies (search for
# requirements.txt anywhere inside the cloned repository)
# ------------------------------------------------------------------
VENV_DIR="${PWD}/.venv"
python -m venv "${VENV_DIR}"
source "${VENV_DIR}/bin/activate"
pip install --upgrade pip setuptools wheel

REQ_FILE=$(find . -type f -name "requirements.txt" -print -quit || true)
if [[ -n "$REQ_FILE" ]]; then
  echo "Installing dependencies from $REQ_FILE"
  pip install -r "$REQ_FILE"
else
  echo "No requirements.txt found in the repository; skipping Python dependency installation."
fi

# ------------------------------------------------------------------
# Forward any command supplied to the container
# ------------------------------------------------------------------
exec "$@"