#!/usr/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__clearboard.sh

if ! command -v dunst &>/dev/null; then
  echo "dunst could not be found. Please install it."
  exit 1
fi

clipmethod="$XDG_SESSION_TYPE"

function main() {
  if [ "$clipmethod" = "x11" ]; then
    dunstctl close-all
    echo "" | xclip -sel clip
  elif [ "$clipmethod" = "wayland" ]; then
    if command -v cliphist &>/dev/null; then
      cliphist wipe
    fi
    dunstctl close-all
    echo "" | wl-copy
  fi
}

main
