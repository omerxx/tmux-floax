#!/usr/bin/env bash
#
if [ "$(tmux display-message -p '#{session_name}')" = "scratch" ]; then
    # Detach the client
    tmux detach-client
else
    # Check if the session 'scratch' exists
    if tmux has-session -t scratch 2>/dev/null; then
        # Popup that attaches to existing 'scratch' session
        tmux popup -E -w 70% -h 70% "tmux attach-session -t scratch"
    else
        # Create a new session named 'scratch' and attach to it
        tmux new-session -d -c "$(tmux display-message -p '#{pane_current_path}')" -s scratch
        tmux set-option -t scratch status off
        tmux attach-session -t scratch
    fi
fi

# # Detach client and then open a popup to attach to the 'scratch' session
# tmux detach-client
# tmux popup -E -w 90% -h 90% "tmux attach-session -t scratch"
