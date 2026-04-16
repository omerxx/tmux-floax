#!/usr/bin/env bash

envvar_value() {
    tmux showenv -g "$1" | cut -d '=' -f 2-
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
DEFAULT_TITLE='FloaX: C-M-s 󰘕   C-M-b 󰁌   C-M-f 󰊓   C-M-r 󰑓   C-M-e 󱂬   C-M-d '
FLOAX_SESSION_NAME=$(envvar_value FLOAX_SESSION_NAME)
DEFAULT_SESSION_NAME='scratch'
FLOAX_PER_SESSION=$(envvar_value FLOAX_PER_SESSION)

# Returns the effective floax session name.
# When per-session is enabled: <base>_<origin>
# When per-session is disabled: <base> (global)
floax_effective_session() {
    local origin="$1"
    local base="${FLOAX_SESSION_NAME:-$DEFAULT_SESSION_NAME}"
    if [ "$FLOAX_PER_SESSION" = "true" ]; then
        echo "${base}_${origin}"
    else
        echo "$base"
    fi
}

# Checks if a session name is a floax session
is_floax_session() {
    local session="$1"
    local base="${FLOAX_SESSION_NAME:-$DEFAULT_SESSION_NAME}"
    if [ "$FLOAX_PER_SESSION" = "true" ]; then
        [[ "$session" == "${base}_"* ]]
    else
        [[ "$session" == "$base" ]]
    fi
}


set_bindings() {
    tmux bind -n C-M-s run "$CURRENT_DIR/zoom-options.sh in"
    tmux bind -n C-M-b run "$CURRENT_DIR/zoom-options.sh out"
    tmux bind -n C-M-f run "$CURRENT_DIR/zoom-options.sh full"
    tmux bind -n C-M-r run "$CURRENT_DIR/zoom-options.sh reset"
    tmux bind -n C-M-e run "$CURRENT_DIR/embed.sh embed"
    tmux bind -n C-M-d run "$CURRENT_DIR/zoom-options.sh lock" 
    tmux bind -n C-M-u run "$CURRENT_DIR/zoom-options.sh unlock"
}

unset_bindings() {
    tmux unbind -n C-M-s
    tmux unbind -n C-M-b
    tmux unbind -n C-M-f 
    tmux unbind -n C-M-r 
    tmux unbind -n C-M-e 
    tmux unbind -n C-M-d 
    tmux unbind -n C-M-u 
}

tmux_version() {
  tmux -V | cut -d ' ' -f 2 | sed 's/[^0-9.]//g'
}

# Checks whether tmux version is >= 3.3
is_tmux_version_supported() {
    local version
    IFS='.' read -r -a version < <(tmux_version)

    if [ "${version[0]}" -gt 3 ]; then
        return 0
    fi

    # Minor version can be a number or alphanumeric, e.g. 3.3 vs 3.3a
    if [ "${version[0]}" -eq 3 ] && [ "${version[1]//[!0-9]}" -ge 3 ]; then
        return 0
    fi

    return 1
}

tmux_popup() {
    local target_session="${1:-${FLOAX_SESSION_NAME:-$DEFAULT_SESSION_NAME}}"
    # TODO: make this optional:
    current_dir=$(tmux display -p '#{pane_current_path}')
    scratch_path=$(tmux display -t "$target_session" -p '#{pane_current_path}')
    if [ "$scratch_path" != "$current_dir" ] && [ "$FLOAX_CHANGE_PATH" = "true" ]; then
        tmux send-keys -R -t "$target_session" " cd \"$current_dir\"" C-m
    fi

    if is_tmux_version_supported; then
        if ! pop "$target_session"; then
            tmux setenv -g FLOAX_WIDTH "$(tmux_option_or_fallback '@floax-width' '80%')"
            tmux setenv -g FLOAX_HEIGHT "$(tmux_option_or_fallback '@floax-height' '80%')"
            pop "$target_session"
        fi
    else
        tmux display-message \
            -d 2000 \
            "FloaX requires tmux version 3.3 or newer"
    fi
}

pop() {
    local target_session="${1:-${FLOAX_SESSION_NAME:-$DEFAULT_SESSION_NAME}}"

    FLOAX_WIDTH=$(envvar_value FLOAX_WIDTH)
    FLOAX_HEIGHT=$(envvar_value FLOAX_HEIGHT)

    FLOAX_TITLE=$(envvar_value FLOAX_TITLE)
    if [ -z "$FLOAX_TITLE" ]; then
        FLOAX_TITLE="$DEFAULT_TITLE"
    fi

    tmux set-option -t "$target_session" detach-on-destroy on
    tmux popup \
        -S fg="$FLOAX_BORDER_COLOR" \
        -s fg="$FLOAX_TEXT_COLOR" \
        -T "$FLOAX_TITLE" \
        -w "$FLOAX_WIDTH" \
        -h "$FLOAX_HEIGHT" \
        -b rounded \
        -E \
        "tmux attach-session -t \"$target_session\""
}
