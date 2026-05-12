#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utils.sh"

# Get the outer client's tty so we can target it after detaching the inner client.
# Must be called BEFORE tmux detach-client.
get_outer_client() {
    local origin_session
    origin_session="$(envvar_value ORIGIN_SESSION)"
    tmux list-clients -t "${origin_session:-0}" -F '#{client_tty}' 2>/dev/null | head -1
}

resize() {
    # '#{window_width}' returns the inner pane size (excluding popup border).
    # But tmux popup -w/-h includes the border (2 lines/chars for -b rounded).
    # So we add 2 to convert from inner size to popup size.
    current_width=$(tmux display -p '#{window_width}')
    current_height=$(tmux display -p '#{window_height}')
    current_width=$((current_width + 2))
    current_height=$((current_height + 2))
    if [ $((current_height+step)) -le 0 ] || [ $((current_width+step)) -le 0 ]; then
        return
    fi
    ORIGIN_SESSION="$(envvar_value ORIGIN_SESSION)"
    if [ $((current_height+step)) -gt "$(tmux display -p -t "${ORIGIN_SESSION}:" '#{window_height}')" ] || 
        [ $((current_width+step)) -gt "$(tmux display -p -t "${ORIGIN_SESSION}:" '#{window_width}')" ]; then
        return
    fi
    tmux setenv -g FLOAX_WIDTH $((current_width+step))
    tmux setenv -g FLOAX_HEIGHT $((current_height+step))
    local outer_client
    outer_client="$(get_outer_client)"
    tmux detach-client
    if [ -n "$outer_client" ]; then
        pop_with_client "$outer_client"
    else
        tmux_popup
    fi
}

full_screen() {
    tmux setenv -g FLOAX_WIDTH 100%
    tmux setenv -g FLOAX_HEIGHT 100%
    local outer_client
    outer_client="$(get_outer_client)"
    tmux detach-client
    if [ -n "$outer_client" ]; then
        pop_with_client "$outer_client"
    else
        tmux_popup
    fi
}

reset_size() {
    tmux setenv -g FLOAX_WIDTH "$(tmux_option_or_fallback '@floax-width' '80%')" 
    tmux setenv -g FLOAX_HEIGHT "$(tmux_option_or_fallback '@floax-height' '80%')" 
    local outer_client
    outer_client="$(get_outer_client)"
    tmux detach-client
    if [ -n "$outer_client" ]; then
        pop_with_client "$outer_client"
    else
        tmux_popup
    fi
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
    local outer_client
    outer_client="$(get_outer_client)"
    tmux detach-client
    if [ -n "$outer_client" ]; then
        pop_with_client "$outer_client"
    else
        tmux_popup
    fi
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
