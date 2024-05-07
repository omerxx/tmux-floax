#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utils.sh"

resize() {
    current_width=$(tmux display -p '#{window_width}')
    current_height=$(tmux display -p '#{window_height}')
    if [ $((current_height+step)) -le 0 ] || [ $((current_width+step)) -le 0 ]; then
        return
    fi
    ORIGIN_SESSION="$(envvar_value ORIGIN_SESSION)"
    if [ $((current_height+step)) -gt "$(tmux display -p -t "$ORIGIN_SESSION" '#{window_height}')" ] || 
        [ $((current_width+step)) -gt "$(tmux display -p -t "$ORIGIN_SESSION" '#{window_width}')" ]; then
        return
    fi
    tmux setenv -g FLOAX_WIDTH $((current_width+step))
    tmux setenv -g FLOAX_HEIGHT $((current_height+step))
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

unlock_bindings() {
    set_bindings
    change_popup_title "$DEFAULT_TITLE"
}

lock_bindings() {
    unset_bindings
    tmux bind -n C-M-u run "$CURRENT_DIR/zoom-options.sh unlock" 
    change_popup_title "Bindings locked. Unlock with [Ctrl-Alt-u]"
}

change_popup_title() {
    tmux setenv -g FLOAX_TITLE "$1"
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
    lock)
        lock_bindings
        ;;
    unlock)
        unlock_bindings
        ;;
esac
