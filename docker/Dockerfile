# --------------------------------------------------------------
# Base image: CUDA 12.1 runtime (public, no NGC auth required)
# --------------------------------------------------------------
FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04

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
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3 - && \
    pip3 install --no-cache-dir torch torchvision

# ------------------------------------------------------------------
# Create a non-root user (good practice)
# ------------------------------------------------------------------
ARG USERNAME=appuser
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} ${USERNAME} && \
    useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME}

WORKDIR /workspace

# ------------------------------------------------------------------
# Copy entrypoint script (handles cloning, venv, dependencies)
# ------------------------------------------------------------------
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER ${USERNAME}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]