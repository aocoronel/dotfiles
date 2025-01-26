#!/bin/env bash

if [ ! -z "$TERM" ]; then
  terminal=$(grep "TERM" .env)
  $terminal
fi

if tmux has-session -t master; then
  $TERM -e tmux attach-session -t master
else
  tmuxp load master -d
  $TERM -e tmux attach-session -t master
fi
