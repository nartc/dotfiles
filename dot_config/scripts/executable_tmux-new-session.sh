#!/bin/bash

# Create a new session with a new directory (two-step flow)
# Step 1: Select base directory
# Step 2: Type new subdirectory name

DIRS=(
    "$HOME/code/github"
    "$HOME/code/sandbox"
    "$HOME/code/obsidian"
    "$HOME/.zsh_functions"
    "$HOME/.config"
)

# Step 1: Select base directory
base=$({ printf '%s\n' "${DIRS[@]}"; fd . "${DIRS[@]}" --type=dir --max-depth=3 --full-path; } |
    sed "s|^$HOME/||" |
    fzf --header="Select base directory")

[[ -z "$base" ]] && exit 0

# Step 2: Read new directory name
read -p "New directory name: " newdir

[[ -z "$newdir" ]] && exit 0

target="$HOME/$base/$newdir"

# Create directory
mkdir -p "$target" || exit 1

# Create and switch to session
selected_name=$(basename "$target" | tr . _)
if ! tmux has-session -t "=$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$target"
    tmux select-window -t "$selected_name:1"
fi

tmux switch-client -t "=$selected_name"
