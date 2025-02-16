#!/bin/bash

source $HOME/.env

current_command=$(tmux display-message -p "#{pane_current_command}")

if [[ "$current_command" == "nvim" ]]; then
  tmux send-keys -t 0 ":call writefile([fnamemodify(expand('%:p'), ':t')], '/tmp/filename_output.txt')" C-m
  sleep 0.1
  file_name=$(cat /tmp/filename_output.txt)
  file_name=$(echo "$file_name" | sed 's/\.md//; s/th//')

  if [[ -n "$file_name" ]]; then
    tmux display-popup -h 90% -w 90% -E \
      "$SHELL" -c "$SCRIPTS/__tskd.sh \"$file_name\" tmux"
  else
    echo "Could not retrieve the file name."
  fi
else
  echo "Not in nvim."
fi
