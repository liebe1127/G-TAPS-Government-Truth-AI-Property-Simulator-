#!/usr/bin/env bash
# Idempotent dependency refresh for Cursor Cloud Agents.
# Safe to re-run on partially cached VMs.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Ensure uv is available even on fresh shells.
if ! command -v uv >/dev/null 2>&1; then
  if [[ -x "${HOME}/.local/bin/uv" ]]; then
    export PATH="${HOME}/.local/bin:${PATH}"
  else
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="${HOME}/.local/bin:${PATH}"
  fi
fi

echo "[G-TAPS] install: refreshing workspace dependencies from $ROOT"

install_node_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    return 0
  fi
  if [[ ! -f "$dir/package.json" ]]; then
    return 0
  fi

  echo "[G-TAPS] node deps: $dir"
  pushd "$dir" >/dev/null
  if [[ -f package-lock.json ]]; then
    npm ci
  elif [[ -f pnpm-lock.yaml ]]; then
    pnpm install --frozen-lockfile
  elif [[ -f yarn.lock ]]; then
    yarn install --frozen-lockfile
  else
    npm install
  fi
  popd >/dev/null
}

install_python_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    return 0
  fi

  if [[ -f "$dir/uv.lock" ]]; then
    echo "[G-TAPS] uv sync --frozen: $dir"
    (cd "$dir" && uv sync --frozen --all-extras)
  elif [[ -f "$dir/pyproject.toml" ]]; then
    echo "[G-TAPS] uv sync: $dir"
    (cd "$dir" && uv sync --all-extras)
  elif [[ -f "$dir/requirements.txt" ]]; then
    echo "[G-TAPS] venv + pip: $dir"
    python3 -m venv "$dir/.venv"
    # shellcheck disable=SC1091
    source "$dir/.venv/bin/activate"
    pip install -r "$dir/requirements.txt"
    deactivate
  fi
}

# Root workspace scripts (optional thin package.json)
if [[ -f package.json ]]; then
  install_node_dir "."
fi

# App packages
install_node_dir "web"
install_python_dir "api"

# Fallback: root-level Python project
if [[ -f pyproject.toml || -f requirements.txt ]]; then
  install_python_dir "."
fi

echo "[G-TAPS] install: done"
