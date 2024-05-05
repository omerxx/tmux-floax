#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux_option_or_fallback() {
	local option_value
	option_value="$(tmux show-option -gqv "$1")"
	if [ -z "$option_value" ]; then
		option_value="$2"
	fi
	echo "$option_value"
}

tmux bind-key "$(tmux_option_or_fallback "@floax-bind" "p")" run-shell "$CURRENT_DIR/scripts/floax.sh"
tmux bind-key "$(tmux_option_or_fallback "@floax-bind-menu" "P")" run-shell "$CURRENT_DIR/scripts/zoom.sh"

tmux setenv -g FLOAX_WIDTH "$(tmux_option_or_fallback '@floax-width' '80%')" 
tmux setenv -g FLOAX_HEIGHT "$(tmux_option_or_fallback '@floax-height' '80%')" 

eval "$(tmux showenv -s)"
