#!/bin/env bash

# Help Menu
function help() {
  echo "A passmenu-like for otp"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "help                                   - Displays this message and exits"
}

function passmenu-otp() {
  passdir=${PASSWORD_STORE_DIR:-$HOME/.password-store}
  pass=$(find "$passdir" -type f -name '*.gpg' -printf '%P\n' | awk -F. '{print $1}')
  password=$(echo "$pass" | dmenu "$@")
  pass otp -c "$password"
}

case "$1" in
  "help")
    help
    ;;
  "")
    passmenu-otp
    ;;
esac
