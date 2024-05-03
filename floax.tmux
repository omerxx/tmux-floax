#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux bind-key T run-shell "$CURRENT_DIR/scripts/floax.sh"
tmux bind-key + run-shell "$CURRENT_DIR/scripts/zoom.sh"
tmux bind-key - run-shell "$CURRENT_DIR/scripts/zoom-out.sh"
tmux bind-key 1 run-shell "$CURRENT_DIR/scripts/move.sh up"
tmux bind-key 2 run-shell "$CURRENT_DIR/scripts/move.sh down"
tmux bind-key 3 run-shell "$CURRENT_DIR/scripts/move.sh right"
tmux bind-key 4 run-shell "$CURRENT_DIR/scripts/move.sh left"
