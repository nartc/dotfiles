#!/bin/bash

DIRS=(
    "$HOME/code/github"
    "$HOME/code/sandbox"
    "$HOME/code/obsidian"
    "$HOME/.zsh_functions"
    "$HOME/.config"
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$({ printf '%s\n' "${DIRS[@]}"; fd . "${DIRS[@]}" --type=dir --max-depth=3 --full-path; } |
        sed "s|^$HOME/||" |
        fzf)
    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

# Derive default session name from directory
default_name=$(basename "$selected" | tr . _)

# Prompt for session name using fzf (edit and press Enter)
selected_name=$(printf '' | fzf --print-query --query="$default_name" --prompt="Session name: " | head -1)
[[ -z "$selected_name" ]] && exit 0

# Sanitize: replace spaces/dots with underscores
selected_name=$(echo "$selected_name" | tr ' .' '_')

if ! tmux has-session -t "=$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
    tmux select-window -t "$selected_name:1"
fi

tmux switch-client -t "=$selected_name"
