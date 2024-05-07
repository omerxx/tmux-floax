#!/usr/bin/env bash

envvar_value() {
    tmux showenv -g "$1" | cut -d '=' -f 2
}

tmux_option_or_fallback() {
	local option_value
	option_value="$(tmux show-option -gqv "$1")"
	if [ -z "$option_value" ]; then
		option_value="$2"
	fi
	echo "$option_value"
}

FLOAX_WIDTH=$(envvar_value FLOAX_WIDTH)
FLOAX_HEIGHT=$(envvar_value FLOAX_HEIGHT)
FLOAX_BORDER_COLOR=$(envvar_value FLOAX_BORDER_COLOR)
FLOAX_TEXT_COLOR=$(envvar_value FLOAX_TEXT_COLOR)
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLOAX_CHANGE_PATH=$(envvar_value FLOAX_CHANGE_PATH)
FLOAX_TITLE=$(envvar_value FLOAX_TITLE)
DEFAULT_TITLE='FloaX Options: [+/-] change size | [C-f] fullscreen | [C-r] reset | [C-e] embed | [alt-L] lock bindings'

if [ -z "$FLOAX_TITLE" ]; then
    FLOAX_TITLE="$DEFAULT_TITLE"
fi

tmux_popup() {
    FLOAX_WIDTH=$(envvar_value FLOAX_WIDTH)
    FLOAX_HEIGHT=$(envvar_value FLOAX_HEIGHT)
    FLOAX_TITLE=$(envvar_value FLOAX_TITLE)
    # TODO: make this optional:
    current_dir=$(tmux display -p '#{pane_current_path}')
    scratch_path=$(tmux display -t scratch -p '#{pane_current_path}')
    if [ "$scratch_path" != "$current_dir" ] && [ "$FLOAX_CHANGE_PATH" = "true" ]; then
        tmux send-keys -R -t scratch "cd $current_dir" C-m
    fi
    tmux popup \
        -S fg="$FLOAX_BORDER_COLOR" \
        -s fg="$FLOAX_TEXT_COLOR" \
        -T "$FLOAX_TITLE" \
        -w "$FLOAX_WIDTH" \
        -h "$FLOAX_HEIGHT" \
        -b rounded \
        -E \
        "tmux attach-session -t scratch;clear" 
}

set_bindings() {
    tmux bind -n "-" run "$CURRENT_DIR/zoom-options.sh in"
    tmux bind -n "+" run "$CURRENT_DIR/zoom-options.sh out"
    tmux bind -n C-f run "$CURRENT_DIR/zoom-options.sh full"
    tmux bind -n C-r run "$CURRENT_DIR/zoom-options.sh reset"
    tmux bind -n C-e run "$CURRENT_DIR/embed.sh embed"
    tmux bind -n M-L run "$CURRENT_DIR/zoom-options.sh lock" 
    tmux bind -n M-U run "$CURRENT_DIR/zoom-options.sh unlock"
}

unset_bindings() {
    tmux unbind -n "-" 
    tmux unbind -n "+" 
    tmux unbind -n "C-f" 
    tmux unbind -n "C-r" 
    tmux unbind -n "C-e" 
    tmux unbind -n "M-L" 
}
