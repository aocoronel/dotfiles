#!/usr/bin/env bash

function open_tmuxp_term() {
  local select="$1"

  if tmux has-session -t "$select" 2>/dev/null; then
    exec "$TERMCMD" -e tmux attach-session -t "$select"
  else
    tmuxp load "$select" -d && exec "$TERMCMD" -e tmux attach-session -t "$select"
  fi
}

function open_tmuxp() {
  local select="$1"

  if tmux has-session -t "$select" 2>/dev/null; then
    tmux attach-session -t "$select"
  else
    tmuxp load "$select" -d && tmux attach-session -t "$select"
  fi
}

function close_tmux() {
  local select="$1"

  if tmux has-session -t "$select"; then
    tmux kill-session -t "$select" && notify-send -u low "Session $select has been closed"
  else
    echo "Session $select isn't running"
    notify-send -u normal "Session $select isn't running"
  fi
}
