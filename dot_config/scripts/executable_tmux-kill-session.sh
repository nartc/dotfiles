#!/usr/bin/env bash

# Select session to kill
target=$(tmux list-sessions -F '#{session_name}' | fzf --header='Kill session')

# Exit if nothing selected
[[ -z "$target" ]] && exit 0

current=$(tmux display-message -p '#{session_name}')

if [[ "$target" == "$current" ]]; then
    # Killing current session - need to switch first
    other=$(tmux list-sessions -F '#{session_name}' | grep -v "^${target}$" | fzf --header='Switch to (before kill)')

    [[ -z "$other" ]] && exit 0

    tmux switch-client -t "$other"
fi

tmux kill-session -t "$target"
