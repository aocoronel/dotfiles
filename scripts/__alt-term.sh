#!/bin/env bash

if tmux has-session -t master; then
  kitty tmux attach-session -t master
else
  tmuxp load master -d
  kitty tmux attach-session -t master
fi
