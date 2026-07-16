#!/usr/bin/env bash

set -euo pipefail

command -v brew >/dev/null 2>&1 || {
  printf 'Homebrew is required before running the macOS package phase.\n' >&2
  exit 1
}

brew bundle --file=- <<'EOF'
# Taps
tap "derailed/k9s"
tap "jandedobbeleer/oh-my-posh"
tap "jesseduffield/lazydocker"
tap "kopecmaciej/vi-mongo"
tap "mongodb/brew"
tap "sst/tap"

# ─────────────────────────────────────────────
# Formulae
# ─────────────────────────────────────────────
brew "age"
brew "agent-browser"
brew "awscli"
brew "azure-cli"
brew "bob"
brew "chezmoi"
brew "coreutils"
brew "ente-cli"
brew "fd"
brew "fnm"
brew "fop"
brew "fzf"
brew "gemini-cli"
brew "gh"
brew "go"
brew "jq"
brew "lazygit"
brew "maven"
brew "mkcert"
brew "mongosh"
brew "mpd"
brew "mpv"
brew "neovim"
brew "nx"
brew "openjdk@17"
brew "openjdk@21"
brew "pnpm"
brew "pstree"
brew "pyenv"
brew "python@3.12"
brew "ralph-orchestrator"
brew "rebar3"
brew "slides"
brew "sponge"
brew "tmux"
brew "tmux-sessionizer"
brew "tree"
brew "tree-sitter-cli"
brew "trivy"
brew "uv"
brew "wxwidgets"
brew "derailed/k9s/k9s"
brew "jandedobbeleer/oh-my-posh/oh-my-posh"
brew "jesseduffield/lazydocker/lazydocker"
brew "kopecmaciej/vi-mongo/vi-mongo"
brew "mongodb/brew/mongodb-database-tools"
brew "sst/tap/opencode"

# ─────────────────────────────────────────────
# Casks
# ─────────────────────────────────────────────
cask "1password"
cask "1password-cli"
cask "brave-browser"
cask "bruno"
cask "chatgpt"
cask "claude"
cask "cleanshot"
cask "codex"
cask "cursor"
cask "discord"
cask "dotnet-sdk"
cask "ente-auth"
cask "firefox"
cask "gcloud-cli"
cask "ghostty"
cask "google-chrome"
cask "homerow"
cask "jetbrains-toolbox"
cask "karabiner-elements"
cask "keysmith"
cask "kitty"
cask "linear"
cask "loom"
cask "mongodb-compass"
cask "ngrok"
cask "nordvpn"
cask "notion"
cask "obsidian"
cask "orbstack"
cask "raycast"
cask "screenflow"
cask "slack"
cask "superhuman"
cask "superset"
cask "superwhisper"
cask "telegram"
cask "visual-studio-code"
cask "zed"
cask "zoom"

# ─────────────────────────────────────────────
# Fonts (5)
# ─────────────────────────────────────────────
cask "font-adwaita-mono-nerd-font"
cask "font-commit-mono-nerd-font"
cask "font-hack-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "font-ubuntu-mono-nerd-font"
cask "font-zed-mono-nerd-font"

# uv-managed tools from current machine
uv "sqlit-tui"
EOF
