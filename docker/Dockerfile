# --------------------------------------------------------------
# Base image: NVIDIA PyTorch image (includes CUDA, Python, and PyTorch)
# --------------------------------------------------------------
FROM nvcr.io/nvidia/pytorch:25.09-py3

# ------------------------------------------------------------------
# Install Python 3, pip, and PyTorch (all public packages)
# ------------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    wget \
    git \
    ca-certificates \
    python3 \
    python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    # Install uv (a fast Python installer) for later use in entrypoint
    curl -LsSf https://astral.sh/uv/install.sh | sh

# ------------------------------------------------------------------
# Create a non-root user (good practice)
# ------------------------------------------------------------------
ARG USERNAME=appuser
ARG UID=1000
ARG GID=1000

# Create group and user if they do not already exist (ignore errors if they do)
RUN groupadd -g ${GID} ${USERNAME} 2>/dev/null || true && \
    useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} 2>/dev/null || true

WORKDIR /workspace

# ------------------------------------------------------------------
# Copy entrypoint script (handles cloning, venv, dependencies)
# ------------------------------------------------------------------
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER ${USERNAME}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]