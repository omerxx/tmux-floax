#!/usr/bin/env bash

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
tmux detach-client
tmux popup -E "$motion" "tmux attach-session -t \"$FLOAX_SESSION_NAME\""
# tmux display-message "$pane_top $pane_left $motion"
