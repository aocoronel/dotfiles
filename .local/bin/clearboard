#!/usr/bin/env bash

clipmethod="$XDG_SESSION_TYPE"

function main() {
  if [ "$clipmethod" = "x11" ]; then
    echo "" | xclip -sel clip
  elif [ "$clipmethod" = "wayland" ]; then
    echo "" | wl-copy
    [ -x "$(command -v cliphist)" ] && cliphist wipe
  fi
  [ -x "$(command -v dunst)" ] && dunstctl close-all
}

main
