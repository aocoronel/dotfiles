#!/bin/env bash

# Help Menu

function help() {
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "help                                   - Displays this message and exits"
}

vaultdir=$(ls "$VAULT")

# Tmux Integration

function cd-tmux() {
  local SESSION_NAME=$(basename "/mnt/$govault" | tr ' .:' '_')
  tmux new-session -d -s "$SESSION_NAME" -c "/mnt/$govault"
  tmux attach -t "$SESSION_NAME"
}

# Core Function

function unlock() {
  # $VAULT is an user defined directory variable set in .bashenv
  # Originally $VAULT contains pgp encrypted files as .asc files
  # It also contains folders encrypted with gocryptfs
  govault=$(echo "$vaultdir" | fzf --height 40% --prompt "Select vault to unlock: ")
  if [ ! -d "/mnt/$govault" ]; then
    echo "No directory found at /mnt/$govault. Creating one now..."
    sudo mkdir "/mnt/$govault"
    sudo chown "$USER:$USER" "/mnt/$govault"
    echo "Directory /mnt/$govault created."
  fi
  gocryptfs "$VAULT/$govault" "/mnt/$govault" &&
  cd-tmux &&
  fusermount3 -u "/mnt/$govault" && echo "$govault has been umounted successfully!"
  sleep 1
  exit 0
}

case "$1" in
  "help")
    help
    ;;
  "")
    unlock
    ;;
esac
