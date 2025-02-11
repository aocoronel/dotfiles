#!/bin/env bash

if [ -z "$TERMCMD" ]; then
  eval $(awk -F= '/^(TERMCMD)=/ {print "export " $1 "=" $2}' ~/.localenv)
fi

function tmux_profile() {
  if tmux has-session -t "$session"; then
    $TERMCMD -e tmux attach-session -t "$session"
  else
    tmuxp load "$session" -d
    $TERMCMD -e tmux attach-session -t "$session"
  fi
}

case "$1" in
"edit") session=edit ;;
"master") session=master ;;
esac

tmux_profile
