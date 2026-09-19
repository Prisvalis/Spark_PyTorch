# --------------------------------------------------------------
# Base image: NVIDIA official PyTorch (CUDA 12.1 + cuDNN 8)
# --------------------------------------------------------------
FROM nvidia/pytorch:latest

# ------------------------------------------------------------------
# Install Python 3.12 (via deadsnakes PPA) and basic utilities
# ------------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        wget \
        git \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.12 \
        python3.12-dev \
        python3.12-venv && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.12 100 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 100 && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12

# ------------------------------------------------------------------
# Create a non‑root user (good practice on DGX nodes)
# ------------------------------------------------------------------
ARG USERNAME=appuser
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} ${USERNAME} && \
    useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME}

WORKDIR /workspace

# ------------------------------------------------------------------
# Entrypoint script (will be copied later)
# ------------------------------------------------------------------
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER ${USERNAME}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]