#!/usr/bin/env bash

# https://github.com/user/dotfiles/blob/main/scripts/exit.sh

source "$HOME/.scriptenv"

function umount_dir() {
  if [ -z "$(ls -A "$BEELZEBUB")" ]; then
    echo "Directory '$BEELZEBUB' is empty"
    return 0
  else
    if fusermount -u -z "$BEELZEBUB"; then
      echo "Successfully unmounted $BEELZEBUB"
      return 0
    else
      echo "Failed to unmount $BEELZEBUB"
      return 1
    fi
  fi
}

function stop_services() {
  echo "Stopping Podman Containers..."
  podman stop --all >/dev/null
  echo "Stopping Tmux Sessions..."
  tmux kill-server
  echo "Umounting Drives..."
  umount_dir
  echo "Slamming open Tombs..."
  tomb slam
}

function main() {
  stop_services
  if ! umount_dir; then
    echo "Failed to umount $BEELZEBUB"
    echo "Repeating the process..."
    stop_services
  else
    echo "See ya!"
    sleep 2
    poweroff
  fi
}

main
