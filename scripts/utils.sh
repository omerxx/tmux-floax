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
FLOAX_TITLE=$(envvar_value FLOAX_TITLE)

tmux_popup() {
    FLOAX_WIDTH=$(envvar_value FLOAX_WIDTH)
    FLOAX_HEIGHT=$(envvar_value FLOAX_HEIGHT)
        tmux popup \
            -S fg="$FLOAX_BORDER_COLOR" \
            -s fg="$FLOAX_TEXT_COLOR" \
            -T "$FLOAX_TITLE" \
            -w "$FLOAX_WIDTH" \
            -h "$FLOAX_HEIGHT" \
            -b rounded \
            -E \
            "tmux attach-session -t scratch" 
            # "tmux switch-client -t scratch"
}
