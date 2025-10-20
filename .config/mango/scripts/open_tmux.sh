#!/usr/bin/env bash

# "Open a dedicated terminal with tmux and switch
# predefined sessions using Tmuxp"

function tpo() {
  local session_name="$1"
  [ -z "$session_name" ] && session_name=master
  local class_name="tmux"

  if pgrep -af "alacritty --class $class_name" >/dev/null; then
    if tmux has-session -t "$session_name" 2>/dev/null; then
      tmux switch-client -t "$session_name"
    else
      tmuxp load "$session_name" -d
      tmux switch-client -t "$session_name"
    fi
  else
    if tmux has-session -t "$session_name" 2>/dev/null; then
      exec alacritty --class "$class_name" -e tmux attach-session -t "$session_name"
    else
      exec alacritty --class "$class_name" -e tmuxp load "$session_name"
    fi
  fi
}

tpo "$1"
