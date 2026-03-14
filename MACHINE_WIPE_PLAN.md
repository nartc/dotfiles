# Machine Wipe Plan with chezmoi

> Generated: 2026-02-05
> Last updated before wipe: ____

---

## Table of Contents
1. [Pre-Wipe Setup](#1-pre-wipe-setup)
2. [Dotfiles to Manage](#2-dotfiles-to-manage)
3. [Encrypted Secrets](#3-encrypted-secrets)
4. [Homebrew Brewfile](#4-homebrew-brewfile)
5. [Manual Backups](#5-manual-backups)
6. [macOS Preferences Script](#6-macos-preferences-script)
7. [Post-Wipe: New Machine Setup](#7-post-wipe-new-machine-setup)
8. [Manual Setup Checklist](#8-manual-setup-checklist)

---

## 1. Pre-Wipe Setup

### 1.1 Install chezmoi and age
```bash
brew install chezmoi age
```

### 1.2 Initialize chezmoi
```bash
chezmoi init
```

### 1.3 Generate age encryption key
```bash
mkdir -p ~/.config/chezmoi
age-keygen -o ~/.config/chezmoi/key.txt
```

**CRITICAL**: Backup `~/.config/chezmoi/key.txt` to:
- [ ] USB drive
- [ ] Printed copy in safe location
- [ ] Password manager (if not company-owned)

### 1.4 Configure chezmoi

Create `~/.config/chezmoi/chezmoi.toml`:
```toml
encryption = "age"
[age]
    identity = "~/.config/chezmoi/key.txt"
    recipient = "age1xxxxxxxxx..."  # public key from key.txt
```

### 1.5 Create `.chezmoiignore`

Create `~/.local/share/chezmoi/.chezmoiignore` to exclude IDE/editor junk and macOS artifacts:
```
.idea
.idea/**
.DS_Store
```

### 1.6 Create GitHub repo
```bash
cd ~/.local/share/chezmoi
git init
# After adding all files:
gh repo create dotfiles --private --source=. --push
```

---

## 2. Dotfiles to Manage

### Shell Configuration
| File | Command |
|------|---------|
| `~/.zshrc` | `chezmoi add ~/.zshrc` |
| `~/.zshenv` | `chezmoi add ~/.zshenv` |
| `~/.zprofile` | `chezmoi add ~/.zprofile` |
| `~/.zsh_functions/` | `chezmoi add ~/.zsh_functions` |

### Editors
| File | Command |
|------|---------|
| `~/.config/nvim/` | `chezmoi add ~/.config/nvim` |
| `~/.ideavimrc` | `chezmoi add ~/.ideavimrc` |
| `~/.config/zed/settings.json` | `chezmoi add ~/.config/zed/settings.json` |
| `~/.config/zed/keymap.json` | `chezmoi add ~/.config/zed/keymap.json` |

### Terminal & Multiplexer
| File | Command |
|------|---------|
| Ghostty config | `chezmoi add ~/Library/Application\ Support/com.mitchellh.ghostty/config` |
| Ghostty themes | `chezmoi add ~/.config/ghostty/themes` |
| `~/.config/tmux/` | `chezmoi add ~/.config/tmux` |

### Git
| File | Command |
|------|---------|
| `~/.gitconfig` | `chezmoi add ~/.gitconfig` |
| `~/.config/git/ignore` | `chezmoi add ~/.config/git/ignore` |

### Tools
| File | Command |
|------|---------|
| `~/.config/gh/` | `chezmoi add ~/.config/gh` |
| `~/.config/karabiner/` | `chezmoi add ~/.config/karabiner` |
| `~/.config/scripts/` | `chezmoi add ~/.config/scripts` |
| `~/.yarnrc` | `chezmoi add ~/.yarnrc` |

> **Skip**: `~/.config/raycast/extensions/` — store-installed extension bundles (compiled JS), no secrets. Re-downloaded automatically when signing into Raycast. Use Raycast export/import (section 5.4) instead.

### Claude Code (`~/.claude/`)
| File | Command | Notes |
|------|---------|-------|
| `~/.claude/CLAUDE.md` | `chezmoi add ~/.claude/CLAUDE.md` | Custom instructions (agent delegation, plan mode rules) |
| `~/.claude/settings.json` | `chezmoi add ~/.claude/settings.json` | MCP server configs |
| `~/.claude/agents/` | `chezmoi add ~/.claude/agents` | 5 custom agents: a11y-ui-expert, auth0-research-specialist, frontend-architect, gemini-analyzer, nx-typecheck-invoker |
| `~/.claude/commands/` | `chezmoi add ~/.claude/commands` | Custom slash commands (local-pr-review.md) |

**Skip**: skills/ (managed via `npx skills`), history.jsonl, transcripts/, todos/, debug/, cache/

### OpenCode (`~/.config/opencode/`)
| File | Command | Notes |
|------|---------|-------|
| `~/.config/opencode/opencode.json` | `chezmoi add ~/.config/opencode/opencode.json` | MCP servers (github, linear, exa, context7, grep-app) |
| `~/.config/opencode/agent/` | `chezmoi add ~/.config/opencode/agent` | 10 agents: a11y, auth0, brainstormer, codebase-learner, frontend-architect, frontend-ui-ux, librarian, nx-typecheck, orchestrator, planner |

**Skip**: skills/ (managed via `npx skills`), node_modules/, bun.lock

---

## 3. Encrypted Secrets

### SSH Keys
```bash
chezmoi add --encrypt ~/.ssh/id_ed25519
chezmoi add --encrypt ~/.ssh/id_ed25519.pub
chezmoi add ~/.ssh/config  # not encrypted
```

### NPM Token
```bash
chezmoi add --encrypt ~/.npmrc
```
> **Post-wipe**: Rotate this token on npmjs.com after restoring — the old token should be revoked.

### License Keys
Create `~/.config/licenses.txt`:
```
# License Keys - KEEP SECURE

## Homerow
Key: XXXX-XXXX-XXXX-XXXX
Purchase date: ____
Email: ____

## CleanShot X
Key: XXXX-XXXX-XXXX-XXXX
License Manager: https://licenses.cleanshot.com/
Email: ____

## Screenflow
Serial: XXXX-XXXX-XXXX-XXXX
Purchase date: ____
```

Then encrypt:
```bash
chezmoi add --encrypt ~/.config/licenses.txt
```

### Claude Desktop MCP Config
```bash
chezmoi add --encrypt ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

Contains sensitive tokens:
- `OBSIDIAN_API_KEY`
- `GITHUB_PERSONAL_ACCESS_TOKEN`

### ngrok Config
```bash
chezmoi add --encrypt ~/Library/Application\ Support/ngrok/ngrok.yml
```

Contains:
- `authtoken`
- Tunnel configs (app1: 4202, app2: 4203)

### Work Project Overrides
**Location**: `/Users/nartc/code/github/nrwl/ocean/env.override`

Option 1 - Store in chezmoi and symlink:
```bash
# Add to chezmoi (encrypt if contains secrets)
chezmoi add --encrypt ~/.config/work/ocean-env.override

# After chezmoi apply, symlink to project:
ln -sf ~/.config/work/ocean-env.override /Users/nartc/code/github/nrwl/ocean/env.override
```

Option 2 - Just document in manual checklist (if recreating is easy)

---

## 4. Homebrew Brewfile

Create `~/.local/share/chezmoi/run_onchange_before_install-packages-darwin.sh.tmpl`:

```bash
{{- if eq .chezmoi.os "darwin" -}}
#!/bin/bash

brew bundle --no-lock --file=/dev/stdin <<EOF
# Taps
tap "derailed/k9s"
tap "jandedobbeleer/oh-my-posh"
tap "jesseduffield/lazydocker"
tap "kopecmaciej/vi-mongo"
tap "mongodb/brew"
tap "sst/tap"

# ─────────────────────────────────────────────
# Formulae (32)
# ─────────────────────────────────────────────
brew "age"
brew "awscli"
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
brew "neovim"
brew "nx"
brew "openjdk@17"
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
brew "wxwidgets"
brew "derailed/k9s/k9s"
brew "jandedobbeleer/oh-my-posh/oh-my-posh"
brew "jesseduffield/lazydocker/lazydocker"
brew "kopecmaciej/vi-mongo/vi-mongo"
brew "mongodb/brew/mongodb-database-tools"
brew "sst/tap/opencode"

# ─────────────────────────────────────────────
# Casks (50)
# ─────────────────────────────────────────────
cask "1password"
cask "1password-cli"
cask "brave-browser"
cask "claude"
cask "cleanshot"
cask "cloudflare-warp"
cask "cursor"
cask "discord"
cask "dotnet-sdk"
cask "ente-auth"
cask "firefox"
cask "gcloud-cli"
cask "ghostty"
cask "google-chrome"
cask "google-cloud-sdk"
cask "homerow"
cask "jetbrains-toolbox"
cask "karabiner-elements"
cask "keysmith"
cask "linear-linear"
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
cask "spotify"
cask "superhuman"
cask "superwhisper"
cask "telegram"
cask "visual-studio-code"
cask "zed"
cask "zen-browser"
cask "zoom"

# ─────────────────────────────────────────────
# Fonts (5)
# ─────────────────────────────────────────────
cask "font-adwaita-mono-nerd-font"
cask "font-commit-mono-nerd-font"
cask "font-hack-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "font-ubuntu-mono-nerd-font"
EOF
{{ end -}}
```

---

## 5. Manual Backups

### 5.1 Obsidian Vault
**Location**: `/Users/nartc/code/obsidian/chau note`

Backup entire folder to:
- [ ] External drive
- [ ] Cloud storage (iCloud, Google Drive, etc.)

### 5.2 Claude Desktop Projects
Projects stored in IndexedDB (not exportable). Manual workaround:

1. Open Claude Desktop
2. For each Project you want to keep:
   - Copy Project instructions
   - Copy any important context/artifacts
   - Save to `~/.config/claude-projects/<project-name>.md`
3. Add to chezmoi: `chezmoi add ~/.config/claude-projects/`

### 5.3 JetBrains IDE Settings
1. Open any JetBrains IDE (IntelliJ, WebStorm, etc.)
2. File → Manage IDE Settings → Export Settings
3. Save ZIP file to backup location
4. Note: `.ideavimrc` is managed by chezmoi separately

### 5.4 Raycast Settings
1. Open Raycast
2. Preferences → Advanced → Export
3. Save to backup location

### 5.5 Shell History (Optional)
```bash
# Export recent history (encrypted — history may contain tokens/passwords in command args)
tail -n 3000 ~/.zsh_history > ~/.config/zsh_history_backup.txt
chezmoi add --encrypt ~/.config/zsh_history_backup.txt
```

---

## 6. macOS Preferences Script

Create `~/.local/share/chezmoi/run_once_after_macos-defaults.sh.tmpl`:

```bash
{{- if eq .chezmoi.os "darwin" -}}
#!/bin/bash

set -e

# ─────────────────────────────────────────────
# Folder Setup
# ─────────────────────────────────────────────
mkdir -p ~/code/github ~/code/sandbox ~/Desktop/screenshots

# ─────────────────────────────────────────────
# Security & Power
# ─────────────────────────────────────────────
# Ask for admin password upfront
sudo -v
# Keep-alive: update sudo timestamp
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Set standby delay to 24 hours (default is 1 hour)
sudo pmset -a standbydelay 86400

# Disable "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Require password immediately after sleep or screen saver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# ─────────────────────────────────────────────
# Dock
# ─────────────────────────────────────────────
defaults write com.apple.dock tilesize -int 42
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 54
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock autohide-time-modifier -float 0.5
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock show-recents -bool false

# ─────────────────────────────────────────────
# Keyboard
# ─────────────────────────────────────────────
# Disable press-and-hold for character popup
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Fastest key repeat
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
# Enable Tab in modal dialogs
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# ─────────────────────────────────────────────
# Text Input
# ─────────────────────────────────────────────
# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Disable auto-capitalize
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Disable period with double-space
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# ─────────────────────────────────────────────
# Trackpad
# ─────────────────────────────────────────────
# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# ─────────────────────────────────────────────
# Mission Control
# ─────────────────────────────────────────────
# Don't auto-rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false
# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# ─────────────────────────────────────────────
# Menu Bar
# ─────────────────────────────────────────────
# Always show menu bar (not auto-hide)
defaults write NSGlobalDomain _HIHideMenuBar -bool false
# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# ─────────────────────────────────────────────
# Sound
# ─────────────────────────────────────────────
# Disable startup chime
sudo nvram StartupMute=%01
# Disable UI sound effects
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0
# Keep volume change feedback (commented out to keep it)
# defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 0

# ─────────────────────────────────────────────
# Safari
# ─────────────────────────────────────────────
# Enable Develop menu
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
# Show full URL in address bar
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
# Don't auto-open "safe" downloads
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# ─────────────────────────────────────────────
# Window Animations
# ─────────────────────────────────────────────
# Speed up window resize animation
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# ─────────────────────────────────────────────
# Security
# ─────────────────────────────────────────────
# Enable firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
# Note: Remote login (SSH) left enabled

# ─────────────────────────────────────────────
# Bluetooth
# ─────────────────────────────────────────────
# Show Bluetooth in menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true

# ─────────────────────────────────────────────
# Finder
# ─────────────────────────────────────────────
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid .DS_Store on network/USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ─────────────────────────────────────────────
# Screenshots
# ─────────────────────────────────────────────
defaults write com.apple.screencapture location ~/Desktop/screenshots && killall SystemUIServer

# ─────────────────────────────────────────────
# Apply changes
# ─────────────────────────────────────────────
for app in "Dock" "Finder"; do
    killall "${app}" >/dev/null 2>&1
done

echo "Done. Note that some of these changes require a logout/restart to take effect."
{{ end -}}
```

**Source**: Based on your existing [dot_laptop.settings](https://github.com/nartc/dotfiles/blob/main/dot_laptop.settings)

---

## 7. Post-Wipe: New Machine Setup

### Step 1: Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Step 2: Install chezmoi and age
```bash
brew install chezmoi age
```

### Step 3: Restore age key
Copy `key.txt` from USB backup to:
```bash
mkdir -p ~/.config/chezmoi
# Copy key.txt to ~/.config/chezmoi/key.txt
```

### Step 4: Initialize and apply chezmoi
```bash
chezmoi init --apply nartc
```

This will:
- Clone your dotfiles repo
- Decrypt all encrypted secrets
- Run Brewfile to install all packages
- Apply macOS defaults
- Symlink all config files

### Step 5: Follow Manual Setup Checklist (below)

---

## 8. Manual Setup Checklist

### Immediate (After chezmoi apply)

**SSH Keys**
- [ ] `chmod 600 ~/.ssh/id_ed25519`
- [ ] `ssh-add ~/.ssh/id_ed25519`
- [ ] Test: `ssh -T git@github.com`

**Shell**
- [ ] Restart terminal or `source ~/.zshrc`
- [ ] Verify oh-my-posh prompt loads

### Authentication

**Browsers**
- [ ] Chrome: Sign in with Google account → passwords sync
- [ ] Zen Browser: Sign in with Firefox Sync account
- [ ] Brave: Sign in (optional, if using sync)

**CLI Tools**
- [ ] `gh auth login`
- [ ] `gcloud auth login`
- [ ] `gcloud config set account chau@nrwl.io`
- [ ] `gcloud config set project nartc-gemini`

**Apps (Account-based)**
- [ ] 1Password: Sign in
- [ ] Slack: Sign in to workspaces
- [ ] Discord: Sign in
- [ ] Telegram: Sign in
- [ ] Notion: Sign in
- [ ] Superhuman: Sign in
- [ ] Spotify: Sign in
- [ ] NordVPN: Sign in
- [ ] Linear: Sign in
- [ ] Loom: Sign in
- [ ] Zoom: Sign in

### License Keys

Open `~/.config/licenses.txt` (decrypted by chezmoi) and enter keys:

- [ ] **Homerow**: Open app → Enter license key
- [ ] **CleanShot X**: Open app → Enter license key
  (Or retrieve from https://licenses.cleanshot.com/)
- [ ] **Screenflow**: Open app → Enter serial number

### IDE & Editor Setup

**JetBrains**
- [ ] Open JetBrains Toolbox (auto-installed)
- [ ] Install desired IDEs (IntelliJ, WebStorm, etc.)
- [ ] File → Manage IDE Settings → Import Settings → Select backup ZIP
- [ ] `.ideavimrc` already restored by chezmoi

**Neovim**
- [ ] Open nvim → Lazy.nvim will auto-install plugins
- [ ] Run `:checkhealth` to verify

### Tool-Specific Setup

**Raycast**
- [ ] Open Raycast
- [ ] Preferences → Advanced → Import → Select backup file
- [ ] Set up window management hotkeys

**Karabiner Elements**
- [ ] Open Karabiner (config restored by chezmoi)
- [ ] Grant accessibility permissions when prompted

**Homerow**
- [ ] Open Homerow
- [ ] Grant accessibility permissions
- [ ] Enter license key

**Obsidian**
- [ ] Restore vault from backup to `/Users/nartc/code/obsidian/chau note`
- [ ] Open Obsidian → Open folder as vault

**Claude Desktop**
- [ ] MCP config restored by chezmoi
- [ ] Manually recreate Projects from exported markdown files

**Claude Code (CLI)**
- [ ] CLAUDE.md, settings.json, agents/, commands/ restored by chezmoi
- [ ] Install skills: `npx skills` (find-skills, local-pr-reviewer-setup, remotion-best-practices, slidev, react-best-practices)

**OpenCode**
- [ ] opencode.json, agent/ restored by chezmoi
- [ ] Install skills: `npx skills` (find-skills, local-pr-reviewer-setup, remotion-best-practices, slidev)

### Development Environment

**Node.js (fnm)**
```bash
fnm install 20.19.0
fnm default 20.19.0
fnm install 22.14.0
fnm install 24.12.0
```

**Python (pyenv)**
```bash
pyenv install 3.12.12
pyenv global 3.12.12
```

**Elixir/Erlang**
```bash
# Install elixir-install
# Reference: https://github.com/taylor/kiex or asdf

# Current versions from .zshrc:
# Elixir: 1.18.3-otp-27
# OTP: 27.2.3
```

**Bun**
```bash
curl -fsSL https://bun.sh/install | bash
```

**tmux**
- [ ] Open tmux
- [ ] Press `prefix + I` to install TPM plugins

### Work Project Setup

**Ocean env.override**
```bash
# After cloning nrwl/ocean repo, symlink the env.override:
ln -sf ~/.config/work/ocean-env.override /Users/nartc/code/github/nrwl/ocean/env.override
```

### Kubernetes (if needed)

```bash
# Re-authenticate to GKE clusters
gcloud container clusters get-credentials nx-cloud-application \
  --region us-east1 \
  --project nxclouddevelopment

gcloud container clusters get-credentials nxclouddevelopment-workflows-cluster \
  --region us-central1 \
  --project nxclouddevelopment
```

---

## Quick Reference

### chezmoi Commands
```bash
chezmoi add <file>           # Add file to chezmoi
chezmoi add --encrypt <file> # Add encrypted file
chezmoi edit <file>          # Edit managed file
chezmoi diff                 # Show pending changes
chezmoi apply                # Apply changes
chezmoi update               # Pull and apply from repo
chezmoi cd                   # Go to source directory
```

### Backup age key
```bash
# Location
~/.config/chezmoi/key.txt

# View public key (for chezmoi.toml recipient)
grep "public key" ~/.config/chezmoi/key.txt
```

### GitHub Dotfiles Repo
```
github.com/nartc/dotfiles (private)
```

---

## Resolved

- **macOS defaults**: Updated with your actual settings from [dot_laptop.settings](https://github.com/nartc/dotfiles/blob/main/dot_laptop.settings)
- **Obsidian**: Keep local, backup to external drive
- **GitHub PAT in Claude MCP config**: Will regenerate after wipe
