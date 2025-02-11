#!/bin/env bash

if [ -z "$TERMCMD" ]; then
  eval $(awk -F= '/^(TERMCMD|EDITOR)=/ {print "export " $1 "=" "\"" $2 "\""}' ~/.localenv)
fi

function tp() {
  session=$(find "$HOME/.config/tmuxp/" -type f -name '*.yaml' -printf '%P\n' | awk -F. '{print $1}')
  select=$(echo "$session" | rofi -dmenu)
  if [[ -n "$select" ]]; then
    if tmux has-session -t "$select"; then
      $TERMCMD -e tmux attach-session -t "$select"
    else
      tmuxp load "$select" -d
      $TERMCMD -e tmux attach-session -t "$select"
    fi
  fi
}

tp
