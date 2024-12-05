#!/bin/env bash

# Help Menu

function help() {
  echo "Password Clipper"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "help                                   - Displays this message and exits"
}

vault="${VAULT:-$HOME/Vault/}"

function clipper() {
  # $VAULT is an user defined directory variable set in .bashenv
  # Originally $VAULT contains pgp encrypted files as .asc files
  # It also contains folders encrypted with gocryptfs
  export pass=$(ls $vault | grep ".asc" | fzf --height 40% --prompt "Select pgp file to output: ")
  if [ ! -f "$pass" ]; then
    echo "Exitting..."
    exit 1
  fi
  gpg --decrypt $vault/$pass | xclip -sel clip
  sleep 10
  # Clears the clipboard
  echo "" | xclip -sel clip
}

case "$1" in
  "help")
    help
    ;;
  "")
    clipper
    ;;
esac
