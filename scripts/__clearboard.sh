#!/usr/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__clearboard.sh

clipmethod="$XDG_SESSION_TYPE"

function main() {
  if [ "$clipmethod" = "x11" ]; then
    if command -v dunst &>/dev/null; then
      dunstctl close-all
    fi
    echo "" | xclip -sel clip
  elif [ "$clipmethod" = "wayland" ]; then
    if command -v cliphist &>/dev/null; then
      cliphist wipe
    fi
    if command -v dunst &>/dev/null; then
      dunstctl close-all
    fi
    echo "" | wl-copy
  fi
}

main
