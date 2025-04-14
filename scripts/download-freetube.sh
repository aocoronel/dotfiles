#!/usr/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/download-freetube.sh

if ! command -v jq &>/dev/null; then
  echo "jq could not be found. Please install it."
  exit 1
fi

file=$1   # FreeTube.db
format=$2 # video/audio
action=$3 # store - Don't download

if [[ -z "$file" || -z "$format" ]]; then
  echo "Usage: $0 [file] [format]"
  echo "Format: video/audio"
  exit 1
fi

function get_url() {
  playlist=$(jq -r '.playlistName' $file | fzf --prompt "Select a playlist: ")
  if [[ -z "$playlist" ]]; then
    echo "No playlist selected. Exiting."
    exit 1
  fi
  jq -r "select(.playlistName == \"$playlist\") | .videos[].videoId | \"https://youtu.be/\" + ." "$file" >$PWD/"$playlist".txt
  if [[ ! -s "$playlist.txt" ]]; then
    echo "No videos found in the selected playlist. Exiting."
    exit 1
  fi
}

function get_data() {
  playlist=$(jq -r '.playlistName' $file | fzf --prompt "Select a playlist: ")
  if [[ -z "$playlist" ]]; then
    echo "No playlist selected. Exiting."
    exit 1
  fi
  jq -r --arg playlist "$playlist" '
  select(.playlistName == $playlist) |
  .videos[] |
  "https://youtu.be/\(.videoId) | \(.author) - \(.title)"
' "$file" >"$PWD/$playlist.txt"
  if [[ ! -s "$playlist.txt" ]]; then
    echo "No videos found in the selected playlist. Exiting."
    exit 1
  fi
}

function download() {
  ~/scripts/__download-youtube.sh -b $PWD/"$playlist".txt $format
}

function main() {
  case "$action" in
  store)
    get_data
    ;;
  *)
    get_url
    download
    ;;
  esac
}

main
