#!/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__convert-mp4.sh

sizebefore_mb=$(du -ms | awk '{print $1}')
sizebefore_kb=$(du -ks | awk '{print $1}')

videoformats=("mkv" "webm" "m4v" "mpeg" "ogv" "avi" "mov")

for format in "${videoformats[@]}"; do
  find . -type f -iname "*.$format" | while read -r video_file; do
    mp4_file="${video_file%."$format"}.mp4"

    ffmpeg -nostdin -i "$video_file" -vcodec libx264 -crf 23 -preset medium -acodec aac -b:a 128k "$mp4_file"

    rm "$video_file"

    echo "Converted: $video_file to $mp4_file"
  done
done

sizeafter_mb=$(du -ms | awk '{print $1}')
sizeafter_kb=$(du -ks | awk '{print $1}')

declare -i A=("$sizebefore_mb"-"$sizeafter_mb")
declare -i B=("$sizebefore_kb"-"$sizeafter_kb")

if [ "$A" -eq 0 ]; then
  echo "$B" KB have been freed!
else
  echo "$A" MB have been freed!
fi
