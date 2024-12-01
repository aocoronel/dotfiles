#!/bin/env bash

# Help Menu

function help() {
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "help                                   - Displays this message and exits"
}

# Tmux Integration

function cd-tmux() {
  local SESSION_NAME=$(basename "/mnt/" | tr ' .:' '_')
  tmux new-session -d -s "$SESSION_NAME" -c /mnt/
  tmux attach -t "$SESSION_NAME"
}

# Core Function

function unlock() {
  # $VAULT is an user defined directory variable set in .bashenv
  # Originally $VAULT contains pgp encrypted files as .asc files
  # It also contains folders encrypted with gocryptfs
  export vault=$(ls $VAULT/ | fzf --height 40% --prompt "Select vault to unlock: ")  
  gocryptfs $VAULT/"$vault" /mnt/ &&
  cd-tmux &&
  fusermount3 -u /mnt/
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
