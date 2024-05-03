#!/usr/bin/env bash

tmux detach-client
tmux popup -E -w 70% -h 70% "tmux attach-session -t scratch"
