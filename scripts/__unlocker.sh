#!/bin/env bash

if [ -z "$VAULT" ]; then
  source "$HOME/.env"
fi

vaultdir=$(ls "$VAULT")

function cd-tmux() {
  local SESSION_NAME=$(basename "/mnt/go/$govault" | tr ' .:' '_')
  tmux new-session -d -s "$SESSION_NAME" -c "/mnt/go/$govault"
  tmux attach -t "$SESSION_NAME"
}

function unlock() {
  govault=$(echo "$vaultdir" | fzf --height 40% --prompt "Select vault to unlock: ")
  if [ ! -d "/mnt/go/$govault" ]; then
    echo "No directory found at /mnt/go/$govault. Creating one now..."
    sudo mkdir "/mnt/go/$govault"
    sudo chown "$USER:$USER" "/mnt/go/$govault"
    echo "Directory /mnt/go/$govault created."
  fi
  gocryptfs "$VAULT/$govault" "/mnt/go/$govault" &&
  cd-tmux &&
  fusermount3 -u "/mnt/go/$govault" && echo "$govault has been umounted successfully!"
  sleep 1
  exit 0
}

unlock
