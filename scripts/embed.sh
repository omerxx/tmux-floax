#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utils.sh"

# Must set these BEFORE using them in functions
ORIGIN_SESSION="$(envvar_value ORIGIN_SESSION)"

# Derive the effective per-session floax session name
effective_session="$(floax_effective_session "$ORIGIN_SESSION")"

embed() {
    unset_bindings
    number_of_windows=$(tmux list-windows -t "$effective_session" | wc -l)
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
    if ! tmux has-session -t "$effective_session" 2>/dev/null; then
        tmux new-session -d -s "$effective_session"
        tmux set-option -t "$effective_session" status off
    fi
    tmux movew -t "$effective_session"
    tmux_popup "$effective_session"
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
