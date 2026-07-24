# G-TAPS Cursor Cloud Agent base image
# Do not COPY the project — Cursor checks out the workspace separately.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    git \
    jq \
    unzip \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    sudo \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Non-root ubuntu user (Cursor Cloud convention)
RUN id -u ubuntu >/dev/null 2>&1 || useradd -m -s /bin/bash ubuntu \
    && usermod -aG sudo ubuntu \
    && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu

# Node.js 22 (LTS) via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && corepack enable \
    && corepack prepare pnpm@latest --activate

# uv (fast Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && mv /root/.local/bin/uv /usr/local/bin/uv \
    && mv /root/.local/bin/uvx /usr/local/bin/uvx || true

USER ubuntu
WORKDIR /home/ubuntu

# Smoke-check tooling is on PATH for the agent user
RUN node -v && npm -v && python3 --version && uv --version
