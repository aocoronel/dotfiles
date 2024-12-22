#!/bin/env bash

# Help Menu
function help() {
  echo "Obsidian File Picker over Rofi"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "help                                   - Displays this message and exits"
}

if [ -z "$OBSIDIAN" ]; then
  source "$HOME/.env"
fi

function obsidian() {
  # Originally $OBSIDIAN contain the path to an Obsidian Vault
  note=$(find "$OBSIDIAN" -type f -name '*.md' -printf '%P\n' | awk -F. '{print $1}')
  select=$(echo "$note" | rofi -dmenu -i "$@")
  kitty -e nvim "$OBSIDIAN/$select.md"
}

case "$1" in
  "help")
    help
    ;;
  "")
    obsidian
    ;;
esac
