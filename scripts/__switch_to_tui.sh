#!/usr/bin/env bash

set -eo pipefail

TASK_DESCRIPTION="$1"

if [ -z "$TASK_DESCRIPTION" ]; then
  echo "No description is given. Exitting..."
  exit 1
fi

if ! tmux has-session -t "task"; then
  tmuxp load "task" -d
  sleep 0.1
fi

tmux send-keys -t task:taskwarrior "tt" C-m
tmux send-keys -t task:taskwarrior "/description:$TASK_DESCRIPTION" C-m

tmux switch-client -t task
