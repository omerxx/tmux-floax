#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utils.sh"

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

ORIGIN_SESSION="$(envvar_value ORIGIN_SESSION)"
