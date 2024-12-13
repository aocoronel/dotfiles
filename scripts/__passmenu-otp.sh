#!/bin/env bash

# Help Menu
function help() {
  echo "A passmenu-like for otp"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "help                                   - Displays this message and exits"
}

function error() {
  notify-send -u normal "Selected pass entry doesn't contains an OTP." --expire-time=3000; exit 1
}

function passmenu-otp() {
  passdir=${PASSWORD_STORE_DIR:-$HOME/.password-store}
  pass=$(find "$passdir" -type f -name '*.gpg' -printf '%P\n' | awk -F. '{print $1}')
  password=$(echo "$pass" | rofi -dmenu "$@")
  pass otp -c "$password" || error
  notify-send -u critical "OTP copied to clipboard. Clearing in 10 seconds" --expire-time=10000 --wait && echo "" | xclip -sel clip
}

case "$1" in
  "help")
    help
    ;;
  "")
    passmenu-otp
    ;;
esac
