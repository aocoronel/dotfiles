#!/usr/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__tmuxp-open.sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/lib/get_env.sh"
source "$SCRIPT_DIR/lib/tmux_functions.sh"

function main() {
  session=$(find "$HOME/.config/tmuxp/" -type f -name '*.yaml' -printf '%P\n' | awk -F. '{print $1}')
  if [ -z "$session" ]; then
    echo "Failed to get tmuxp files at $HOME/.config/tmuxp"
  fi
  select=$(echo "$session" | rofi -dmenu)
  if [[ -n "$select" ]]; then
    open_tmuxp_term "$select"
  fi
}

get_term # Get TERMCMD env
main
