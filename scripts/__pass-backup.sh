#!/bin/env bash

# Help Menu
function help() {
  echo "pass backup"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "help                                   - Displays this message and exits"
}

vaultdir=$(ls "$VAULT")

function gpg_export() {
  read -p "Insert your email: " email
  gpg --export --armor "$email" > "$HOME/public.gpg"
  gpg --export-secret-keys --armor "$email" > "$HOME/private.gpg"
}

function exportpass() {
  gpg_export
  if [ -z "$PASSWORD_STORE_DIR" ]; then
    source "$HOME/.env"
  fi
  govault=$(echo "$vaultdir" | fzf --height 40% --prompt "Select vault to unlock: ")
  gocryptfs "$VAULT/$govault" "/mnt/go/$govault" &&
  rsync -av --delete "$PASSWORD_STORE_DIR" "/mnt/go/$govault/"
  mv -i "$HOME/private.gpg" "/mnt/go/$govault/"
  mv -i "$HOME/public.gpg" "/mnt/go/$govault/"
  fusermount3 -u "/mnt/go/$govault" && echo "$govault has been umounted successfully!"
}

case "$1" in
  "help")
    help
    ;;
  "")
    exportpass
    ;;
esac
