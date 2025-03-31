#!/usr/bin/env sh

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__batch-media-converter.sh

if ! command -v ffmpeg &>/dev/null; then
  echo "ffmpeg could not be found. Please install it."
  exit 1
fi

media_list=("ogg" "opus" "mp3" "mp4" "mkv" "webm" "m4a")

echo "Media files in the current folder:"

for media in "${media_list[@]}"; do
  find . -maxdepth 1 -type f -iname "*.$media"
done

read -p "Choose source format: " source
read -p "Choose wanted format: " dest

for file in *."$source"; do
  output="${file%.*}.$dest"
  ffmpeg -nostdin -i "$file" -preset medium -acodec aac -b:a 128k "$output"
  echo "Converted: $file to $output"
done
