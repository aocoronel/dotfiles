#!/bin/env bash

if tmux has-session -t master; then
  ghostty -e tmux attach-session -t master
else
  tmuxp load master -d
  ghostty -e tmux attach-session -t master
fi
