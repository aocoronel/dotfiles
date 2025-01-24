#!/bin/env bash

function rsync_base() {
  rsync --progress -avh --delete --files-from=$SCRIPTS/rsync/rsync-home.txt "$HOME/" "$HOME/home/";
  rsync --progress -avh --delete --files-from=$SCRIPTS/rsync/rsync-config.txt "$HOME/.config/" "$HOME/home/.config/";
  rsync --progress -avh --delete --files-from=$SCRIPTS/rsync/rsync-local.txt "$HOME/.local/share/" "$HOME/home/.local/share/";
  rsync --progress -avh --delete --exclude=.config/ "$HOME/dotfiles/" "$HOME/home/dotfiles/"
}

function rsync_root() {
  rsync --progress -avh --delete --files-from=$SCRIPTS/rsync/rsync-home.txt "$HOME/" "$HOME/home/";
  rsync --progress -avh --delete --files-from=$SCRIPTS/rsync/rsync-config.txt "$HOME/.config/" "$HOME/home/.config/";
  rsync --progress -avh --delete --files-from=$SCRIPTS/rsync/rsync-local.txt "$HOME/.local/share/" "$HOME/home/.local/share/";
  rsync --progress -avh --delete --exclude=.config/ "$HOME/dotfiles/" "$HOME/home/dotfiles/"
}

case "$1" in
  "base")
    rsync_base
    ;;
  "root")
    rsync_root
    ;;
esac
