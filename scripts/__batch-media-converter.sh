#!/bin/env bash

media_list=("ogg" "opus" "mp3" "mp4" "mkv" "webm" "m4a")

echo "Media files in the current folder:"

for media in "${media_list[@]}"; do
  find . -maxdepth 1 -type f -iname "*.$media";
done

read -p "Choose source format: " source
read -p "Choose wanted format: " dest

for file in *."$source"; do
  output="${file%.*}.$dest"
  ffmpeg -i "$file" "$output"
  echo "Converted: $file to $output"
done
