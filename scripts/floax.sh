#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utils.sh"

current_session="$(tmux display -p '#{session_name}')"

if is_floax_session "$current_session"; then
    # We're inside a floax popup — detach to close it
    unset_bindings

    if [ -z "$FLOAX_TITLE" ]; then
        FLOAX_TITLE="$DEFAULT_TITLE"
    fi

    tmux setenv -g FLOAX_TITLE "$FLOAX_TITLE"
    tmux detach-client
else
    # We're in a regular session — open a per-session popup
    tmux setenv -g ORIGIN_SESSION "$current_session"
    effective_session="$(floax_effective_session "$current_session")"

    set_bindings

    if tmux has-session -t "$effective_session" 2>/dev/null; then
        tmux_popup "$effective_session"
    else
        tmux new-session -d -c "$(tmux display-message -p '#{pane_current_path}')" -s "$effective_session"
        tmux set-option -t "$effective_session" status off
        tmux_popup "$effective_session"
    fi
fi
