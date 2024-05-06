#!/usr/bin/env bash

source scripts/utils.sh


embed() {
    tmux movew -t "$ORIGIN_SESSION"
    tmux detach-client
}

pop() {
    tmux movew -t scratch
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
