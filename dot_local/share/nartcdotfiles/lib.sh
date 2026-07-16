#!/usr/bin/env bash

# Internal implementation for nartcdotfiles. It is intentionally sourced by a
# small CLI so callers only need to know `apply` and `check`.

nartcdotfiles_log() {
  printf '==> %s\n' "$*"
}

nartcdotfiles_warn() {
  printf 'WARN: %s\n' "$*" >&2
}

nartcdotfiles_error() {
  printf 'ERROR: %s\n' "$*" >&2
}

nartcdotfiles_platform() {
  local os
  os="$(uname -s)"

  case "$os" in
    Darwin)
      printf 'darwin\n'
      ;;
    Linux)
      if [[ -r /etc/os-release ]]; then
        # /etc/os-release is specified as shell-compatible key/value data.
        # shellcheck disable=SC1091
        source /etc/os-release
        printf 'linux:%s\n' "${ID:-unknown}"
      else
        printf 'linux:unknown\n'
      fi
      ;;
    *)
      printf 'unknown\n'
      ;;
  esac
}

nartcdotfiles_phase_script() {
  local source_root="$1"
  local script_name="$2"
  local script_path="$source_root/dot_local/share/nartcdotfiles/$script_name"

  [[ -f "$script_path" ]] || {
    nartcdotfiles_error "Missing phase script: $script_path"
    return 1
  }

  bash "$script_path"
}

nartcdotfiles_preflight() {
  local source_root="$1"
  local platform
  platform="$(nartcdotfiles_platform)"

  command -v chezmoi >/dev/null 2>&1 || {
    nartcdotfiles_error 'chezmoi must be installed before running this command.'
    return 1
  }
  command -v age >/dev/null 2>&1 || {
    nartcdotfiles_error 'age must be installed before applying encrypted dotfiles.'
    return 1
  }
  [[ -d "$source_root/.git" ]] || {
    nartcdotfiles_error "Chezmoi source is not a Git checkout: $source_root"
    return 1
  }
  [[ -r "$HOME/.config/chezmoi/key.txt" ]] || {
    nartcdotfiles_error 'Missing age identity: ~/.config/chezmoi/key.txt'
    return 1
  }

  case "$platform" in
    darwin|linux:fedora)
      nartcdotfiles_log "Platform detected: $platform"
      ;;
    linux:*)
      nartcdotfiles_error "No package adapter is implemented for $platform yet."
      return 1
      ;;
    *)
      nartcdotfiles_error "Unsupported platform: $platform"
      return 1
      ;;
  esac
}

nartcdotfiles_packages() {
  local source_root="$1"

  case "$(nartcdotfiles_platform)" in
    darwin)
      nartcdotfiles_phase_script "$source_root" packages-darwin.sh
      ;;
    linux:fedora)
      nartcdotfiles_phase_script "$source_root" packages-fedora.sh
      ;;
  esac
}

nartcdotfiles_apply_chezmoi() {
  local source_root="$1"
  chezmoi --source "$source_root" apply --verbose
}

nartcdotfiles_runtimes() {
  local source_root="$1"

  case "$(nartcdotfiles_platform)" in
    darwin)
      nartcdotfiles_phase_script "$source_root" dev-runtimes-darwin.sh
      ;;
    linux:fedora)
      nartcdotfiles_log 'Fedora uses the DNF-provided Node.js and Python runtimes.'
      ;;
  esac
}

nartcdotfiles_macos_defaults() {
  local source_root="$1"

  if [[ "$(nartcdotfiles_platform)" == darwin ]]; then
    nartcdotfiles_phase_script "$source_root" macos-defaults.sh
  else
    nartcdotfiles_log 'Skipping macOS defaults on Linux.'
  fi
}

nartcdotfiles_tmux_plugins() {
  local source_root="$1"
  nartcdotfiles_phase_script "$source_root" tmux-plugins.sh
}

nartcdotfiles_neovim_plugins() {
  command -v nvim >/dev/null 2>&1 || {
    nartcdotfiles_error 'Neovim is required before synchronizing LazyVim plugins.'
    return 1
  }

  nvim --headless '+Lazy! sync' +qa
}

nartcdotfiles_verify() {
  local source_root="$1"
  local command
  local path
  local status

  for command in chezmoi git nvim tmux kitty fzf fd rg; do
    command -v "$command" >/dev/null 2>&1 || {
      nartcdotfiles_error "Required command is unavailable: $command"
      return 1
    }
  done

  for path in \
    "$HOME/.config/kitty/kitty.conf" \
    "$HOME/.config/nvim/init.lua" \
    "$HOME/.config/tmux/tmux.conf" \
    "$HOME/.config/ai/agents.md" \
    "$HOME/.claude/CLAUDE.md" \
    "$HOME/.codex/AGENTS.md" \
    "$HOME/.config/opencode/AGENTS.md"; do
    [[ -e "$path" ]] || {
      nartcdotfiles_error "Expected configuration is missing: $path"
      return 1
    }
  done

  status="$(chezmoi --source "$source_root" status)"
  if [[ -n "$status" ]]; then
    nartcdotfiles_warn 'Chezmoi reports local changes; inspect them before the next apply:'
    printf '%s\n' "$status" >&2
  fi

  cat <<'EOF'
Manual actions are intentionally not automated:
  - authenticate gh, Claude Code, OpenCode providers/MCP, and Codex;
  - grant GUI/accessibility permissions where required;
  - restart the AI harnesses after configuration changes.
EOF
}

nartcdotfiles_run_phase() {
  local state_dir="$1"
  local phase="$2"
  shift 2
  local status

  nartcdotfiles_log "Phase: $phase"
  if "$@"; then
    printf '%s\n' "$phase" > "$state_dir/last-successful-phase"
    nartcdotfiles_log "Completed: $phase"
    return 0
  fi

  status=$?
  {
    printf 'phase=%s\n' "$phase"
    printf 'exit_status=%s\n' "$status"
    printf 'failed_at=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    printf 'retry=%s apply\n' "nartcdotfiles"
  } > "$state_dir/last-failure"
  nartcdotfiles_error "Phase '$phase' failed. Fix the reported issue, then rerun: nartcdotfiles apply"
  return "$status"
}

nartcdotfiles_acquire_lock() {
  local state_dir="$1"
  local lock_dir="$state_dir/lock"
  local pid

  if mkdir "$lock_dir" 2>/dev/null; then
    printf '%s\n' "$$" > "$lock_dir/pid"
    return 0
  fi

  pid=""
  if [[ -r "$lock_dir/pid" ]]; then
    read -r pid < "$lock_dir/pid" || true
  fi
  if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
    nartcdotfiles_error "Another nartcdotfiles process is running (PID $pid)."
    return 1
  fi

  nartcdotfiles_warn 'Removing a stale nartcdotfiles lock.'
  rm -rf "$lock_dir"
  mkdir "$lock_dir"
  printf '%s\n' "$$" > "$lock_dir/pid"
}

nartcdotfiles_apply() {
  local source_root="$1"
  local state_dir="$2"
  local log_file

  mkdir -p "$state_dir"
  nartcdotfiles_acquire_lock "$state_dir"
  trap 'rm -rf "$state_dir/lock"' EXIT

  log_file="$state_dir/apply-$(date -u +%Y%m%dT%H%M%SZ).log"
  exec > >(tee -a "$log_file") 2>&1

  nartcdotfiles_run_phase "$state_dir" preflight nartcdotfiles_preflight "$source_root" || return $?
  nartcdotfiles_run_phase "$state_dir" packages nartcdotfiles_packages "$source_root" || return $?
  nartcdotfiles_run_phase "$state_dir" chezmoi nartcdotfiles_apply_chezmoi "$source_root" || return $?
  nartcdotfiles_run_phase "$state_dir" runtimes nartcdotfiles_runtimes "$source_root" || return $?
  nartcdotfiles_run_phase "$state_dir" macos-defaults nartcdotfiles_macos_defaults "$source_root" || return $?
  nartcdotfiles_run_phase "$state_dir" tmux-plugins nartcdotfiles_tmux_plugins "$source_root" || return $?
  nartcdotfiles_run_phase "$state_dir" neovim-plugins nartcdotfiles_neovim_plugins || return $?
  nartcdotfiles_run_phase "$state_dir" verify nartcdotfiles_verify "$source_root" || return $?

  rm -f "$state_dir/last-failure"
  nartcdotfiles_log "Setup complete. Log: $log_file"
}

nartcdotfiles_check() {
  local source_root="$1"
  nartcdotfiles_preflight "$source_root"
  nartcdotfiles_verify "$source_root"
}
