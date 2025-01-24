#!/bin/env bash

if tmux has-session -t master; then
  $TERM -e tmux attach-session -t master
else
  tmuxp load master -d
  $TERM -e tmux attach-session -t master
fi
