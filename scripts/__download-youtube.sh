#!/bin/env bash

function help() {
cat << eof
Youtube Video Downloader
usage: $0 [option]
available options:
-a, --audio                           - Downloads given YT URL to audio
-b, --batch                           - Downloads all URL in a file to audio
-h, --help                            - Displays this message and exits
-v, --video                           - Downloads all URL in a file to video
eof
}

function clip() {
  URL=$(xclip -o)
  title="$(yt-dlp --get-title $URL)"
  yt-dlp -x -f bestaudio --add-metadata --embed-thumbnail --no-playlist --downloader aria2c --downloader-args '-c -j 3 -x 3 -s 3 -k 1M' "$URL"
  if [ "$?" -eq 0 ]; then
    notify-send -u normal "$title downloaded"
  else
    notify-send -u normal "An error occurred!"
  fi
  exit 0
}

function audio() {
  yt-dlp -x -f bestaudio --add-metadata --embed-thumbnail --no-playlist --downloader aria2c --downloader-args '-c -j 3 -x 3 -s 3 -k 1M' "$URL"
  exit 0
}

function video() {
  yt-dlp -x -f best --add-metadata --embed-thumbnail --no-playlist --downloader aria2c --downloader-args '-c -j 3 -x 3 -s 3 -k 1M' "$URL"
  exit 0
}

function batch() {
  yt-dlp -x -f bestaudio --add-metadata --embed-thumbnail --downloader aria2c --downloader-args '-c -j 3 -x 3 -s 3 -k 1M' -a "$file"
}

if [ "$#" -eq 0 ]; then
    echo "Error: No arguments provided."
    help
    exit 0
fi

while [[ "$1" != "" ]]; do
    case "$1" in
        -a | --audio)
            URL=$2
            download
            shift 2
            ;;
        -b | --batch)
            file=$2
            batch
            shift 2
            ;;
        -v | --video)
            URL=$2
            video
            shift 2
            ;;
        -c | --clip)
            clip
            ;;
    esac
done
