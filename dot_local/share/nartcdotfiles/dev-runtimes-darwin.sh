#!/usr/bin/env bash

set -euo pipefail

log() {
  printf "==> %s\n" "$1"
}

NODE_DEFAULT_VERSION="20.19.0"
NODE_VERSIONS=("20.19.0" "22.14.0" "24.12.0")
PYTHON_VERSION="3.12.12"

command -v fnm >/dev/null 2>&1 || {
  printf 'fnm is required before installing Node.js runtimes.\n' >&2
  exit 1
}
log "Installing Node.js versions with fnm"
for version in "${NODE_VERSIONS[@]}"; do
  if ! fnm list | grep -q "v${version}"; then
    fnm install "$version"
  fi
done

fnm default "$NODE_DEFAULT_VERSION"
fnm exec --using "$NODE_DEFAULT_VERSION" node -v >/dev/null

command -v pyenv >/dev/null 2>&1 || {
  printf 'pyenv is required before installing Python runtimes.\n' >&2
  exit 1
}
log "Installing Python ${PYTHON_VERSION} with pyenv"
if ! pyenv versions --bare | grep -qx "$PYTHON_VERSION"; then
  pyenv install "$PYTHON_VERSION"
fi
pyenv global "$PYTHON_VERSION"

if command -v bun >/dev/null 2>&1; then
  log "Bun already installed"
else
  log "Installing Bun"
  curl -fsSL https://bun.sh/install | bash
fi

log "Development runtime bootstrap complete"
