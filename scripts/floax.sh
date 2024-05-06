#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utils.sh"

tmux setenv -g ORIGIN_SESSION "$(tmux display -p '#{session_name}')"
if [ "$(tmux display-message -p '#{session_name}')" = "scratch" ]; then
    # Detach the client
    tmux unbind -n "-" 
    tmux unbind -n "+" 
    tmux unbind -n "f" 
    tmux unbind -n "r" 
    tmux unbind -n "e" 
    tmux detach-client
else
    # Check if the session 'scratch' exists
    if tmux has-session -t scratch 2>/dev/null; then
        # Popup that attaches to existing 'scratch' session
        tmux bind -n "-" run "$CURRENT_DIR/zoom-options.sh in"
        tmux bind -n "+" run "$CURRENT_DIR/zoom-options.sh out"
        tmux bind -n f run "$CURRENT_DIR/zoom-options.sh full"
        tmux bind -n r run "$CURRENT_DIR/zoom-options.sh reset"
        tmux bind -n e run "$CURRENT_DIR/embed.sh embed"
        tmux_popup
    else
        # Create a new session named 'scratch' and attach to it
        tmux new-session -d -c "$(tmux display-message -p '#{pane_current_path}')" -s scratch
        tmux set-option -t scratch status off
        tmux_popup
    fi
fi
