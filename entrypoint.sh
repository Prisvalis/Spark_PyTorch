#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------
# Required environment variables (provided via .env)
# ------------------------------------------------------------------
:
"${GIT_REPO:?GIT_REPO must be defined in .env}"
GIT_BRANCH="${GIT_BRANCH:-main}"
PROJECT_NAME="${PROJECT_NAME:-$(basename -s .git "$GIT_REPO")}"

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
  cd "${PROJECT_NAME}"
fi

# ------------------------------------------------------------------
# Create a venv with Python 3.12 and install dependencies
# ------------------------------------------------------------------
VENV_DIR="${PWD}/.venv"
python -m venv "${VENV_DIR}"
source "${VENV_DIR}/bin/activate"
pip install --upgrade pip setuptools wheel

if [[ -f "requirements.txt" ]]; then
  echo "Installing dependencies from requirements.txt"
  pip install -r requirements.txt
fi

# ------------------------------------------------------------------
# Forward any command supplied to the container
# ------------------------------------------------------------------
exec "$@"
