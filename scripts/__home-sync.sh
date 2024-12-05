#!/bin/env bash

# Help Menu

function help() {
  echo "Home dotfiles sync tool"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "help                                   - Displays this message and exits"
}

function rsync_home() {
  # $SCRIPTS is an user defined directory set in .bashenv
  # $SCRIPTS is present in $PATH
  # Originally $SCRIPTS contains user created scripts
  # home/ in $HOME is a symlink to an external drive where dotfiles is this git repo
  rsync -av --delete --files-from=$SCRIPTS/rsync/rsync-home.txt "$HOME/" "$HOME/home/";
  rsync -av --delete --files-from=$SCRIPTS/rsync/rsync-config.txt "$HOME/.config/" "$HOME/home/.config/";
  rsync -av --delete --files-from=$SCRIPTS/rsync/rsync-local.txt "$HOME/.local/share/" "$HOME/home/.local/share/";
}

case "$1" in
  "help")
    help
    ;;
  "")
    rsync_home
    ;;
esac
