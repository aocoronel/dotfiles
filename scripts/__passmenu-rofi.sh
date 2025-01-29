#!/bin/env bash

function passmenu() {
  passdir=${PASSWORD_STORE_DIR:-$HOME/.password-store}
  pass=$(find "$passdir" -type f -name '*.gpg' -printf '%P\n' | awk -F. '{print $1}')
  password=$(echo "$pass" | rofi -dmenu "$@")
  pass -c "$password" &&
  notify-send -u critical "Password copied to clipboard. Clearing in 5 seconds" --expire-time=4500 --wait
  sh ~/scripts/__clearboard.sh
}

passmenu
