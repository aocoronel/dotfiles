#!/usr/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__home-sync.sh
# Neostow Reference: https://github.com/aocoronel/neostow/blob/main/src/neostow

# 1. "Make a $HOME backup using rsync"
# 2. "Make a $STOW_DIR backup using rsync"

RSYNC_FILE="$HOME/.rsync-ignore"
STOW_DIR="$HOME/stow/" # Special directory, which I use neostow
DIR=$1

if [ ! -d "$HOME/home" ]; then
  echo "Please, create a new directory or symlink at:"
  echo "$HOME/home"
  exit 1
fi

if [ ! -f "$RSYNC_FILE" ]; then
  echo "You do not have a .rsync-ignore file"
  echo "Create one at $RSYNC_FILE. It works like .gitignore"
fi

function sync_main() {
  # "Mirror the $HOME to $HOME/home/"
  rsync --progress -ah --delete --exclude-from=$HOME/.rsync-ignore "$HOME/" "$HOME/home/"
}

function sync_stow() {
  # "Mirror the $STOW_DIR to specified DIR
  if [ -z "$DIR" ]; then
    DIR=$(realpath /mnt/**/stow/)
    if [ ! -d "$DIR" ]; then
      echo "$DIR does not exist."
      return 1
    fi
  fi
  rsync --progress -ah --delete "$STOW_DIR" "$DIR"
}

function main() {
  sync_main
  if [ -d "$STOW_DIR" ]; then
    sync_stow
  fi
}

main
