#!/usr/bin/env bash

function tpo() {
  local session_name="$1"
  local class_name="tmux-$session_name"
  local title_name="$class_name"

  if [ "$session_name" == "task" ]; then
    class_name="$session_name"
  fi

  if tmux has-session -t "$session_name" 2>/dev/null; then
    if pgrep -f "tmux attach-session -t $session_name" >/dev/null; then
      hyprctl dispatch focuswindow class:"$class_name"
    else
      exec kitty --class "$class_name" --title "$title_name" -e tmux attach-session -t "$session_name"
    fi
  else
    exec kitty --class "$class_name" --title "$title_name" -e tmuxp load "$session_name"
  fi
}

tpo "$1"
