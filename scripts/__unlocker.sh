#!/usr/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__unlocker.sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/lib/get_env.sh"

get_vault

if [ -z "$VAULT" ]; then
  echo "Error: VAULT env at .localenv not found"
  exit 1
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
