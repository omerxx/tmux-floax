#!/usr/bin/env bash

source scripts/utils.sh

resize() {
    tmux setenv -g FLOAX_WIDTH $((FLOAX_WIDTH+step))
    tmux setenv -g FLOAX_HEIGHT $((FLOAX_HEIGHT+step))
    tmux detach-client
    tmux_popup
}

full_screen() {
    tmux setenv -g FLOAX_WIDTH 100%
    tmux setenv -g FLOAX_HEIGHT 100%
    tmux detach-client
    tmux_popup
}

reset_size() {
    tmux setenv -g FLOAX_WIDTH "$(tmux_option_or_fallback '@floax-width' '80%')" 
    tmux setenv -g FLOAX_HEIGHT "$(tmux_option_or_fallback '@floax-height' '80%')" 
    tmux detach-client
    tmux_popup
}

case "$1" in
    in)
        step=-5
        resize
        ;;
    out)
        step=5
        resize
        ;;
    full)
        full_screen
        ;;
    reset)
        reset_size
        ;;
esac
