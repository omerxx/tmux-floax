#!/usr/bin/env bash

direction=$1
case $direction in 
    up)
        motion="-y=10"
        ;;
    down)
        motion="-y=-10"
        ;;
    right)
        motion="-x=10"
        ;;
    left)
        motion="-x=-10"
        ;;
esac;

tmux detach-client
tmux popup -E "$motion" "tmux attach-session -t scratch"
