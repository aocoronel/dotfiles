#!/bin/env bash

# Help Menu
function help() {
  echo "A rofi passmenu"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "help                                   - Displays this message and exits"
}

function passmenu() {
  passdir=${PASSWORD_STORE_DIR:-$HOME/.password-store}
  pass=$(find "$passdir" -type f -name '*.gpg' -printf '%P\n' | awk -F. '{print $1}')
  password=$(echo "$pass" | rofi -dmenu "$@")
  pass -c "$password" &&
  notify-send -u critical "Password copied to clipboard. Clearing in 10 seconds" --expire-time=10000 --wait && echo "" | xclip -sel clip
}

case "$1" in
  "help")
    help
    ;;
  "")
    passmenu
    ;;
esac
