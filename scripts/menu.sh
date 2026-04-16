#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/utils.sh"

# Function to check if the current session is a floax session
check_current_session() {
    current_session=$(tmux display-message -p '#{session_name}')
    if ! is_floax_session "$current_session"; then
        tmux menu \
            "pop current window" p "run \"$CURRENT_DIR/embed.sh pop\"" 
        exit 0
    fi
}

check_current_session
tmux menu \
    "size down" - "run \"$CURRENT_DIR/zoom-options.sh in\"" \
    "size up" + "run \"$CURRENT_DIR/zoom-options.sh out\"" \
    "full screen" f "run \"$CURRENT_DIR/zoom-options.sh full\"" \
    "reset size" r "run \"$CURRENT_DIR/zoom-options.sh reset\"" \
    "embed in session" e "run \"$CURRENT_DIR/embed.sh embed\"" 
    # "move up" u "run \"$CURRENT_DIR/move.sh up\"" \
    # "move left" l "run \"$CURRENT_DIR/move.sh left\"" \
