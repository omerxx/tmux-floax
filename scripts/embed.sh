#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utils.sh"

# Must set these BEFORE using them in functions
ORIGIN_SESSION="$(envvar_value ORIGIN_SESSION)"
if [ -z "$FLOAX_SESSION_NAME" ]; then
    FLOAX_SESSION_NAME="$DEFAULT_SESSION_NAME"
fi

embed() {
    unset_bindings
    number_of_windows=$(tmux list-windows -t "$FLOAX_SESSION_NAME" | wc -l)
    if [ "$number_of_windows" -eq 1 ]; then
        # there's only one window, need to create an alternative
        # before moving the current one to another session
        # otherwise the session dies and popping back won't work
        tmux neww -d
    fi
    tmux movew -t "$ORIGIN_SESSION"
    tmux detach-client
}

pop() {
    # Ensure scratch session exists before trying to move window to it
    if ! tmux has-session -t "$FLOAX_SESSION_NAME" 2>/dev/null; then
        tmux new-session -d -s "$FLOAX_SESSION_NAME"
        tmux set-option -t "$FLOAX_SESSION_NAME" status off
    fi
    tmux movew -t "$FLOAX_SESSION_NAME"
    tmux_popup
}

action=$1
case "$action" in
    embed)
        embed
        ;;
    pop)
        pop
        ;;
esac
