#!/bin/env bash

function tp() {
  session=$(find "$HOME/.config/tmuxp/" -type f -name '*.yaml' -printf '%P\n' | awk -F. '{print $1}')
  select=$(echo "$session" | rofi -dmenu)
  if [[ -n "$select" ]]; then
    if tmux has-session -t "$select"; then
      kitty tmux attach-session -t "$select"
    else
      tmuxp load "$select" -d
      kitty tmux attach-session -t "$select"
    fi
  fi
}

tp
