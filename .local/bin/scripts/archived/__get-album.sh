#!/usr/bin/env bash

ENV_FILE="$HOME/.scriptenv"

if [ -z "$ENV_FILE" ]; then
  echo ".scriptenv is missing at $HOME!"
  return 1
fi

source "$ENV_FILE"

if [ -z "$WALLPAPERS" ]; then
  echo "Error: WALLPAPERS env at .scriptenv not found"
  exit 1
fi

check_command() {
  for cmd in "$@"; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "Error: $cmd could not be found. Please install it." >&2
      exit 1
    fi
  done
}

check_command swayimg

function _fzf() {
  check_command fzf
  fzf --prompt 'Select an album: '
}

function _rofi() {
  check_command rofi
  rofi -dmenu -i -no-levenshtein-sort -width 1000 -p '> ' -mesg "<span color='#7c5cff'>Select an album</span>" "$@"
}

function main() {
  local run
  if [ "$mode" == "fzf" ]; then
    run=_fzf
  elif [ "$mode" == "rofi" ]; then
    run=_rofi
  fi
  export album=$(ls "$WALLPAPERS" | "${run}") && swayimg --gallery "$WALLPAPERS/$album"
}

case "$1" in
"rofi")
  mode=rofi
  main
  ;;
"fzf")
  mode=fzf
  main
  ;;
*)
  mode=fzf
  main
  ;;
esac
