#!/usr/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__tmux-close.sh

if ! command -v rofi &>/dev/null; then
  echo "rofi could not be found. Please install it."
  exit 1
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/lib/tmux_functions.sh"

function main() {
  session=$(tmux ls | awk -F ':' '{print $1}')
  select=$(echo "$session" | rofi -dmenu -p "Select session to attach/load")
  if [[ -n "$select" ]]; then
    close_tmux "$select"
  fi
}

main
