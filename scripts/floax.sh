#!/usr/bin/env bash

source scripts/utils.sh

tmux setenv -g ORIGIN_SESSION "$(tmux display -p '#{session_name}')"
if [ "$(tmux display-message -p '#{session_name}')" = "scratch" ]; then
    # Detach the client
    tmux detach-client
else
    # Check if the session 'scratch' exists
    if tmux has-session -t scratch 2>/dev/null; then

        # Popup that attaches to existing 'scratch' session
        tmux_popup
    else
        # Create a new session named 'scratch' and attach to it
        tmux new-session -d -c "$(tmux display-message -p '#{pane_current_path}')" -s scratch
        tmux set-option -t scratch status off
        tmux_popup
    fi
fi
