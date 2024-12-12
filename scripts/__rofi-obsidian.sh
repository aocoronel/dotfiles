#!/bin/env bash

# Help Menu
function help() {
  echo "Obsidian File Picker over Rofi"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "help                                   - Displays this message and exits"
}

function obsidian() {
  # Originally $OBSIDIAN contain the path to an Obsidian Vault
  note=$(find "$OBSIDIAN" -type f -name '*.md' -printf '%P\n')
  select=$(echo "$note" | rofi -dmenu -i "$@")
  nvim "$OBSIDIAN/$select"
}

case "$1" in
  "help")
    help
    ;;
  "")
    obsidian
    ;;
esac
