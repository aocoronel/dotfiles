#!/bin/env bash

# Help Menu
function help() {
  echo "Clipboard clearer"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "help                                   - Displays this message and exits"
}

function clearboard() {
  echo "" | xclip -sel clip
}

case "$1" in
  "help")
    help
    ;;
  "")
    clearboard
    ;;
esac
