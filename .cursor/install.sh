#!/usr/bin/env bash
# Idempotent dependency refresh for Cursor Cloud Agents.
# Safe to re-run on partially cached VMs.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "[G-TAPS] install: refreshing workspace dependencies from $ROOT"

install_node() {
  if [[ -f package-lock.json ]]; then
    echo "[G-TAPS] npm ci"
    npm ci
  elif [[ -f pnpm-lock.yaml ]]; then
    echo "[G-TAPS] pnpm install --frozen-lockfile"
    pnpm install --frozen-lockfile
  elif [[ -f yarn.lock ]]; then
    echo "[G-TAPS] yarn install --frozen-lockfile"
    yarn install --frozen-lockfile
  elif [[ -f package.json ]]; then
    echo "[G-TAPS] npm install"
    npm install
  else
    echo "[G-TAPS] no Node package manifest yet — skip"
  fi
}

install_python() {
  if [[ -f uv.lock ]]; then
    echo "[G-TAPS] uv sync --frozen"
    uv sync --frozen
  elif [[ -f pyproject.toml ]]; then
    echo "[G-TAPS] uv sync"
    uv sync
  elif [[ -f requirements.txt ]]; then
    echo "[G-TAPS] python -m venv .venv && pip install -r requirements.txt"
    python3 -m venv .venv
    # shellcheck disable=SC1091
    source .venv/bin/activate
    pip install -r requirements.txt
  else
    echo "[G-TAPS] no Python package manifest yet — skip"
  fi
}

install_node
install_python

echo "[G-TAPS] install: done"
