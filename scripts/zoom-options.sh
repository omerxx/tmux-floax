#!/usr/bin/env bash

case "$1" in
    in)
        step=-5
        ;;
    out)
        step=5
        ;;
esac

tmux display-message "$1"
window_width=$(tmux display-message -p '#{window_width}')
window_height=$(tmux display-message -p '#{window_height}')
tmux setenv -g FLOAX_WIDTH $((window_width+step))
tmux setenv -g FLOAX_HEIGHT $((window_height+step))
tmux detach-client
tmux popup -E -w $((window_width+step)) -h $((window_height+step)) 'tmux attach-session -t scratch'
