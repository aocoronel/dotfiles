#!/usr/bin/env bash

ENV_FILE="$XDG_CONFIG_HOME/scriptenv"

if [ -z "$ENV_FILE" ]; then
  echo "scriptenv is missing at $XDG_CONFIG_HOME"
  return 1
fi

source "$ENV_FILE"

if [ -z "$VAULT" ]; then
  echo "Error: VAULT env at scriptenv not found"
  exit 1
fi

vaultdir=$(ls "$VAULT")

function cd-tmux() {
  local SESSION_NAME=$(basename "/mnt/go/$govault" | tr ' .:' '_')
  tmux new-session -d -s "$SESSION_NAME" -c "/mnt/go/$govault"
  tmux attach -t "$SESSION_NAME"
}

function main() {
  govault=$(echo "$vaultdir" | fzf --height 40% --prompt "Select vault to unlock: ")
  if [ ! -d "/mnt/go/$govault" ]; then
    echo "No directory found at /mnt/go/$govault. Creating one now..."
    sudo mkdir "/mnt/go/$govault"
    sudo chown "$USER:users" "/mnt/go/$govault"
    echo "Directory /mnt/go/$govault created."
  fi
  gocryptfs "$VAULT/$govault" "/mnt/go/$govault" &&
    cd-tmux &&
    fusermount -u "/mnt/go/$govault" && echo "$govault has been umounted successfully!"
  sleep 1
  exit 0
}

main
