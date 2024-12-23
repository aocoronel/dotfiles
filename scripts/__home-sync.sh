#!/bin/env bash

function rsync_home() {
  rsync -av --delete --files-from=$SCRIPTS/rsync/rsync-home.txt "$HOME/" "$HOME/home/";
  rsync -av --delete --files-from=$SCRIPTS/rsync/rsync-config.txt "$HOME/.config/" "$HOME/home/.config/";
  rsync -av --delete --files-from=$SCRIPTS/rsync/rsync-local.txt "$HOME/.local/share/" "$HOME/home/.local/share/";
  rsync -av --delete --exclude=.config/ "$HOME/dotfiles/" "$HOME/home/dotfiles/"
}

rsync_home
