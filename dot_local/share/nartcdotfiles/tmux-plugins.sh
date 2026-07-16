#!/usr/bin/env bash

# Keep tmux plugins out of Chezmoi source state. This script creates TPM in an
# atomic directory move, pins TPM itself, and lets TPM install any missing
# configured plugins. It is safe to rerun after an interrupted setup.
set -euo pipefail

readonly plugins_dir="$HOME/.config/tmux/plugins"
readonly tpm_dir="$plugins_dir/tpm"
readonly tpm_bin="$tpm_dir/tpm"
readonly tpm_repository="https://github.com/tmux-plugins/tpm.git"
readonly tpm_commit="99469c4a9b1ccf77fade25842dc7bafbc8ce9946"

command -v git >/dev/null 2>&1 || {
  printf 'git is required before bootstrapping tmux plugins.\n' >&2
  exit 1
}
command -v tmux >/dev/null 2>&1 || {
  printf 'tmux is required before bootstrapping tmux plugins.\n' >&2
  exit 1
}

mkdir -p "$plugins_dir"

if [[ -e "$tpm_dir" && ( ! -d "$tpm_dir/.git" || ! -x "$tpm_bin" ) ]]; then
  backup_dir="${tpm_dir}.incomplete.$(date +%Y%m%d%H%M%S)"
  printf 'Preserving incomplete TPM checkout at %s\n' "$backup_dir" >&2
  mv "$tpm_dir" "$backup_dir"
fi

if [[ ! -e "$tpm_dir" ]]; then
  temporary_dir=$(mktemp -d "$plugins_dir/.tpm-bootstrap.XXXXXX")
  cleanup() { rm -rf "$temporary_dir"; }
  trap cleanup EXIT

  git clone "$tpm_repository" "$temporary_dir"
  git -C "$temporary_dir" checkout --detach "$tpm_commit"
  mv "$temporary_dir" "$tpm_dir"
  trap - EXIT
elif [[ -d "$tpm_dir/.git" ]]; then
  current_commit=$(git -C "$tpm_dir" rev-parse HEAD)
  if [[ "$current_commit" != "$tpm_commit" ]]; then
    git -C "$tpm_dir" fetch origin
    git -C "$tpm_dir" checkout --detach "$tpm_commit"
  fi
fi

"$tpm_dir/bin/install_plugins"
