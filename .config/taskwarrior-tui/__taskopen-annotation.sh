#!/usr/bin/env bash

# Originally created by Piotr1215
# Find the original config here:
# https://github.com/Piotr1215/dotfiles/blob/master/.config/taskwarrior-tui/shortcut-scripts/__taskopen-annotation.sh

TASK_UUID=$1
TASK_ANNOTATED=$(task "$TASK_UUID" | grep "nvimline" | head -n 1)
TASK_DESCRIPTION=$(task "$TASK_UUID" | grep "Description" | sed 's/Description //g')

if [ -z "$TASK_ANNOTATED" ]; then
  echo "Task is not annotated"
  exit 1
fi

function taskopen() {
  sleep 0.1

  # Extracting the line number and file path from the input string
  LINE_NUMBER=$(echo "$TASK_ANNOTATED" | awk -F ':' '{print $2}')
  FILE_PATH=$(echo "$TASK_ANNOTATED" | awk -F ':' '{print $3}')

  # If a task description is provided, search for the line number containing that description
  if [ -n "$TASK_DESCRIPTION" ]; then
    NEW_LINE_NUMBER=$(grep -n -F "$TASK_DESCRIPTION" "$FILE_PATH" | awk -F ':' '{print $1}' | head -n 1)
    if [ -n "$NEW_LINE_NUMBER" ]; then
      LINE_NUMBER=$NEW_LINE_NUMBER
    fi
  fi

  # Capture the file name from the file path without the extension
  FILE_NAME=$(basename "$FILE_PATH" | awk -F '.' '{print $1}')
  DIR_NAME=$(dirname "$FILE_PATH")

  # Create a new tmux session which opens the file with neovim at the specific line number and highlighting it
  cd "$DIR_NAME" && tmux new-session -d -s "$FILE_NAME" "direnv exec . $SHELL -c 'nvim +$LINE_NUMBER $FILE_PATH'"

  # Attach to the new session
  tmux switch-client -t "$FILE_NAME"
}

taskopen
