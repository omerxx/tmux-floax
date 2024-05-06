#!/usr/bin/env bash

# Function to check if the current session name matches "scratch"
check_current_session() {
    current_session=$(tmux display-message -p '#{session_name}')
    if [ "$current_session" != "scratch" ]; then
        exit 0
    fi
}

check_current_session
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux menu \
    "size down" - "run \"$CURRENT_DIR/zoom-options.sh in\"" \
    "size up" + "run \"$CURRENT_DIR/zoom-options.sh out\"" \
    "full screen" f "run \"$CURRENT_DIR/zoom-options.sh full\"" \
    "reset size" r "run \"$CURRENT_DIR/zoom-options.sh reset\"" \
    "move up" u "run \"$CURRENT_DIR/move.sh up\"" \
    "move left" l "run \"$CURRENT_DIR/move.sh left\"" 
