#!/usr/bin/env bash

function tpo() {
  if tmux has-session -t "$1"; then
    exec kitty -e tmux attach-session -t "$1"
  else
    exec kitty -e tmuxp load "$1" -d && tmux attach-session -t "$1"
  fi
}

tpo $1
