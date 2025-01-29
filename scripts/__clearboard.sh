#!/bin/env bash

clipmethod=$(echo "$XDG_SESSION_TYPE")

function clearboard() {
  dunstctl close-all
  if [ "$clipmethod" = "x11" ]; then
    echo "" | xclip -sel clip
  else
    echo "" | wl-copy
  fi
}

clearboard
