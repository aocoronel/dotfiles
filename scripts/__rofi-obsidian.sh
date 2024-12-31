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

workspace=$(cat "$HOME/.config/obsidian-workspace.conf")
workspace_name=$(echo "$workspace" | awk -F '/' '{print $7}')

function open_nvim() {
  note=$(find "$workspace" -type f -name '*.md' -printf '%P\n' | awk -F. '{print $1}')
  select=$(echo "$note" | rofi -dmenu -i "$@")
  if [ "$select" = "" ]; then
    exit 0
  fi
  kitty -e nvim "$workspace/$select.md"
}

function open_obsidian() {
  note=$(find "$workspace" -type f -name '*.md' -printf '%P\n')
  select=$(echo "$note" | rofi -dmenu -i "$@" | awk -F '.' '{print $1}')
  touch "$workspace/$select.md"
  if [ "$select" = "" ]; then
    exit 0
  fi
  obsidian-cli open "$select" --vault "$workspace_name"
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
