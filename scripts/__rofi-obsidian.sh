#!/bin/env bash

function help() {
cat << EOF
Quick Switcher via Rofi
Usage: $0 [option]
Available options:
help                            - Displays this message and exits
o                               - Open note in obsidian
n                               - Open note in nvim
EOF
}

if [ -z "$OBSIDIAN" ]; then
  source "$HOME/.env"
fi

function open_nvim() {
  note=$(find "$OBSIDIAN" -type f -name '*.md' -printf '%P\n' | awk -F. '{print $1}')
  select=$(echo "$note" | rofi -dmenu -i "$@")
  kitty -e nvim "$OBSIDIAN/$select.md"
}

function open_obsidian() {
  note=$(find "$OBSIDIAN" -type f -name '*.md' -printf '%P\n')
  select=$(echo "$note" | rofi -dmenu -i "$@")
  touch "$OBSIDIAN/$select"
  obsidian-cli open "$select" --vault OUROBOROS
}

case "$1" in
  "")
    help
    ;;
  "n")
    open_nvim
    exit 0
    ;;
  "o")
    open_obsidian
    exit 0
    ;;
esac
