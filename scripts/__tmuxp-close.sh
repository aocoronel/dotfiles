#!/bin/env bash

function tc() {
  session=$(tmux ls | awk -F ':' '{print $1}')
  select=$(echo "$session" | rofi -dmenu -p "Select session to attach/load")
  if [[ -n "$select" ]]; then
    if tmux has-session -t "$select"; then
      tmux kill-session -t "$select" && notify-send -u low "Session $select has been closed"
    else
      notify-send -u normal "Session $select isn't running"
    fi
  fi
}

tc
