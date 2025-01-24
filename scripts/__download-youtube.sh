#!/bin/env bash

function help() {
cat << eof
Youtube Video Downloader
Usage: $0 [option] [file] [format]
Available Formats:
audio, video
Available Options:
-a, --audio                           - Downloads given YT URL to audio
-b, --batch [file] [format]           - Downloads all URL in a file to audio
-h, --help                            - Displays this message and exits
-v, --video                           - Downloads all URL in a file to video
eof
}

function audio() {
  URL=$(xclip -o)
  title="$(yt-dlp --get-title $URL)" && notify-send -u normal "Initiating the download..."
  yt-dlp -x -f bestaudio --add-metadata --embed-thumbnail --no-playlist --downloader aria2c --downloader-args '-c -j 3 -x 3 -s 3 -k 1M' "$URL"
  if [ "$?" -eq 0 ]; then
    notify-send -u normal "$title downloaded"
  else
    notify-send -u normal "An error occurred!"
  fi
  exit 0
}

function video() {
  URL=$(xclip -o)
  title="$(yt-dlp --get-title $URL)" && notify-send -u normal "Initiating the download..."
  yt-dlp -x -f best --add-metadata --embed-thumbnail --no-playlist --downloader aria2c --downloader-args '-c -j 3 -x 3 -s 3 -k 1M' "$URL"
  if [ "$?" -eq 0 ]; then
    notify-send -u normal "$title downloaded"
  else
    notify-send -u normal "An error occurred!"
  fi
  exit 0
}

function batch() {
  echo "Downloading from file $file as $format"
  if [ "$format" = "video" ]; then
    yt-dlp -x -f best --add-metadata --embed-thumbnail --no-playlist --downloader aria2c --downloader-args '-c -j 3 -x 3 -s 3 -k 1M' "$URL"
  elif [ "$format" = "audio" ]; then
    yt-dlp -x -f bestaudio --add-metadata --embed-thumbnail --downloader aria2c --downloader-args '-c -j 3 -x 3 -s 3 -k 1M' -a "$file"
  else
    echo "Please choose audio or video, for the file format"
  fi
  exit 0
}

if [ "$#" -eq 0 ]; then
    echo "Error: No arguments provided."
    help
    exit 0
fi

while [[ "$1" != "" ]]; do
    case "$1" in
        -a | --audio)
            audio
            ;;
        -b | --batch)
            file=$2
            format=$3
            batch
            ;;
        -v | --video)
            video
            ;;
    esac
done
