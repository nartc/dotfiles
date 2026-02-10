#!/usr/bin/env bash

# Select session to KEEP (kill all others)
keep=$(tmux list-sessions -F '#{session_name}' | fzf --header='Keep session (kill all others)')

# Exit if nothing selected
[[ -z "$keep" ]] && exit 0

current=$(tmux display-message -p '#{session_name}')

# Switch to the kept session if not already there
if [[ "$current" != "$keep" ]]; then
    tmux switch-client -t "$keep"
fi

# Kill all sessions except the kept one
tmux list-sessions -F '#{session_name}' | grep -v "^${keep}$" | while read -r session; do
    tmux kill-session -t "$session"
done
