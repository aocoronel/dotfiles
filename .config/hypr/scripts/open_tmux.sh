#!/usr/bin/env bash

function tpo() {
  local session_name="$1"
  local class_name="tmux"
  local title_name="$class_name"

  if [[ "$session_name" == "task" ]]; then
    class_name="$session_name"
  fi

  if pgrep -af "kitty --class $class_name" >/dev/null; then
    hyprctl dispatch focuswindow class:"$class_name"
    if tmux has-session -t "$session_name" 2>/dev/null; then
      tmux switch-client -t "$session_name"
    else
      tmuxp load "$session_name" -d
      tmux switch-client -t "$session_name"
    fi
  else
    if tmux has-session -t "$session_name" 2>/dev/null; then
      exec kitty -1 --class "$class_name" --title "$title_name" -e tmux attach-session -t "$session_name"
    else
      exec kitty -1 --class "$class_name" --title "$title_name" -e tmuxp load "$session_name"
    fi
  fi
}

tpo "$1"
