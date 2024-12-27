#!/bin/env bash

### Predefined directories ###
pandora="/mnt/pandora/"
beelzebub="/mnt/beelzebub/"
seth="/mnt/seth/"

function syncbeelzebub() {
  rsync -av --delete $pandora $beelzebub
}

function syncseth() {
  rsync -av --delete $pandora $seth
}
###############################

sourcedrive=$(ls /mnt/ | fzf --prompt "Choose source directory: ")
if [ -z "$sourcedrive" ]; then
  echo "No source directory chosen!"
  exit 1
fi
destdrive=$(ls /mnt/ | fzf --prompt "Choose dest directory: ")
if [ -z "$destdrive" ]; then
  echo "No source directory chosen!"
  exit 1
fi

function sync_external() {
  rsync -av --delete "$sourcedrive" "$destdrive"
}


if [[ "$1" == "-b" ]]; then
  syncbeelzebub
  exit 0
elif [[ "$1" == "-s" ]]; then
  syncseth
  exit 0
elif [[ "$1" == "-h" ]]; then
  echo "Choose hardcoded drive to sync:"
  echo "-b - Beelzebub"
  echo "-s - Seth"
  exit 1
else
  sync_external
  exit 0
fi
