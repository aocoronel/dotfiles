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
  export pass=$(ls $vault | grep ".asc" | fzf --height 40% --prompt "Select pgp file to output: ")
  if [ ! -f "$pass" ]; then
    echo "Exitting..."
    exit 1
  fi
  gpg --decrypt $vault/$pass | xsel --clipboard --input --selectionTimeout 10000
}

case "$1" in
  "help")
    help
    ;;
  "")
    clipper
    ;;
esac
