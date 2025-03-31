#!/usr/bin/env sh

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__get-album.sh

if ! command -v swayimg &>/dev/null; then
  echo "swayimg could not be found. Please install it."
  exit 1
fi

SCRIPT_DIR="$(dirname "$(realpath "")")"
source "$SCRIPT_DIR/lib/get_env.sh"

get_wallpaper

if [ -z "$WALLPAPERS" ]; then
  echo "Error: WALLPAPERS env at .localenv not found"
  exit 1
fi

function _fzf() {
  if ! command -v fzf &>/dev/null; then
    echo "fzf could not be found. Please install it."
    exit 1
  fi
  fzf --prompt 'Select an album: '
}

function _rofi() {
  if ! command -v rofi &>/dev/null; then
    echo "rofi could not be found. Please install it."
    exit 1
  fi
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
