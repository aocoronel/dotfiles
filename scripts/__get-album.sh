#!/bin/env bash

# Help Menu

function help() {
  echo "Album Selector"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "help                                   - Displays this message and exits"
}

wallpapers="${WALLPAPERS:-$HOME/Ente/}"

function get_wallpaper() {
  export album=$(ls $wallpapers | fzf --prompt "Select an album") 
  nsxiv -t $wallpapers/$album
}

case "$1" in
  "help")
    help
    ;;
  "")
    get_wallpaper
    ;;
esac
