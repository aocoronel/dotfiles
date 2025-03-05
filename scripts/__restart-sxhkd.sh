#!/usr/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__restart-sxhkd.sh

pkill sxhkd
tmux kill-session -t key
tmuxp load key -d
