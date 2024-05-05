#!/usr/bin/env bash


FLOAX_WIDTH=$(tmux showenv -g FLOAX_WIDTH | cut -d '=' -f 2)
FLOAX_HEIGHT=$(tmux showenv -g FLOAX_HEIGHT | cut -d '=' -f 2)

if [ "$(tmux display-message -p '#{session_name}')" = "scratch" ]; then
    # Detach the client
    tmux detach-client
else
    # Check if the session 'scratch' exists
    if tmux has-session -t scratch 2>/dev/null; then
        # Popup that attaches to existing 'scratch' session
        tmux popup -E -w "$FLOAX_WIDTH" -h "$FLOAX_HEIGHT" "tmux attach-session -t scratch"
    else
        # Create a new session named 'scratch' and attach to it
        tmux new-session -d -c "$(tmux display-message -p '#{pane_current_path}')" -s scratch
        tmux set-option -t scratch status off
        tmux popup -E -w "$FLOAX_WIDTH" -h "$FLOAX_HEIGHT" "tmux attach-session -t scratch"
        # tmux attach-session -t scratch
    fi
fi
