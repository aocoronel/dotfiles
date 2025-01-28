#!/bin/bash

source "$HOME/.env"

current_command=$(tmux display-message -p "#{pane_current_command}")

if [[ "$current_command" == "nvim" ]]; then
    tmux send-keys -t 0 ':echo expand("%:p")' C-m
    sleep 0.1
    file_name=$(tmux capture-pane -pS - -E - | tail -n 1)

    if [[ -n "$file_name" ]]; then
        tmux display-popup -h 90% -w 90% -E \
          "$SHELL -c '$SCRIPTS/__tskd.sh \"$file_name\" tmux'"
    else
        echo "Could not retrieve the file name."
    fi
else
    echo "Not in nvim."
fi
