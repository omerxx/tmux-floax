#!/usr/bin/env bash

envvar_value() {
    tmux showenv -g "$1" | cut -d '=' -f 2
}

tmux_popup () {
        tmux popup \
            -S fg="$FLOAX_BORDER_COLOR" \
            -s fg="$FLOAX_TEXT_COLOR" \
            -T "$FLOAX_TITLE" \
            -b rounded -E \
            -w "$FLOAX_WIDTH" \
            -h "$FLOAX_HEIGHT" \
            "tmux attach-session -t scratch"
}

FLOAX_WIDTH=$(envvar_value FLOAX_WIDTH)
FLOAX_HEIGHT=$(envvar_value FLOAX_HEIGHT)
FLOAX_BORDER_COLOR=$(envvar_value FLOAX_BORDER_COLOR)
FLOAX_TEXT_COLOR=$(envvar_value FLOAX_TEXT_COLOR)
FLOAX_TITLE=$(envvar_value FLOAX_TITLE)

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
