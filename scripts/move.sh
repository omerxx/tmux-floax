#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utils.sh"

direction=$1
x=$(tmux display-message -p '#{popup_centre_x}')
y=$(tmux display-message -p '#{popup_centre_y}')
case $direction in 
    up)
        step=$((y-10))
        motion="-y $step"
        ;;
    down)
        step=$((y+10))
        motion="-y $step"
        ;;
    right)
        step=$((x+50))
        motion="-x $step"
        ;;
    left)
        step=$((x+20))
        motion="-x $step"
        ;;
esac;

# pane_bottom=$(tmux display-message -p '#{pane_bottom}')
# pane_right=$(tmux display-message -p '#{pane_right}')
ORIGIN_SESSION="$(envvar_value ORIGIN_SESSION)"
effective_session="$(floax_effective_session "$ORIGIN_SESSION")"

tmux detach-client
tmux popup -E "$motion" "tmux attach-session -t \"$effective_session\""
# tmux display-message "$pane_top $pane_left $motion"
