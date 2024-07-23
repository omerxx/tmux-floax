#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utils.sh"

tmux setenv -g ORIGIN_SESSION "$(tmux display -p '#{session_name}')"
if [ "$(tmux display-message -p '#{session_name}')" = "scratch" ]; then
    unset_bindings

    if [ -z "$FLOAX_TITLE" ]; then
        FLOAX_TITLE="$DEFAULT_TITLE"
    fi

    change_popup_title "$FLOAX_TITLE"
    tmux setenv -g FLOAX_TITLE "$FLOAX_TITLE"
    tmux detach-client
else
    # Check if the session 'scratch' exists
    if tmux has-session -t scratch 2>/dev/null; then
        set_bindings
        tmux_popup
    else
        # Create a new session named 'scratch' and attach to it
        tmux new-session -d -c "$(tmux display-message -p '#{pane_current_path}')" -s scratch
        tmux set-option -t scratch status off
        tmux_popup
    fi
fi
