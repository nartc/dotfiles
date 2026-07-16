#!/usr/bin/env bash

# rpm checks make this a no-op once the desired packages are present. A failed
# DNF transaction can be repaired by rerunning `nartcdotfiles apply`.
set -euo pipefail

readonly packages=(
  curl
  fd-find
  fzf
  gcc
  git
  kitty
  make
  neovim
  nodejs
  python3
  ripgrep
  tar
  tmux
  unzip
  wl-clipboard
  xclip
)

missing=()
for package in "${packages[@]}"; do
  rpm -q "$package" >/dev/null 2>&1 || missing+=("$package")
done

if ((${#missing[@]} == 0)); then
  printf 'Fedora prerequisites already installed.\n'
  exit 0
fi

if ! command -v dnf >/dev/null 2>&1; then
  printf 'dnf is required to install: %s\n' "${missing[*]}" >&2
  exit 1
fi

printf 'Installing missing Fedora prerequisites: %s\n' "${missing[*]}"
if [[ $EUID -eq 0 ]]; then
  dnf install -y "${missing[@]}"
else
  sudo -v
  sudo dnf install -y "${missing[@]}"
fi

printf 'Fedora prerequisites installed.\n'
