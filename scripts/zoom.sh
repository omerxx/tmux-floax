#!/usr/bin/env bash

tmux detach-client
tmux popup -E -w 90% -h 90% "tmux attach-session -t scratch"
