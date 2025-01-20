#!/bin/env bash

sizebefore=$(du -ms | awk '{print $1}')

videoformats=("mkv" "webm" "m4a")

for format in "${videoformats[@]}"; do
    find . -type f -iname "*.$format" | while read -r video_file; do
        mp4_file="${video_file%.$format}.mp4"

        ffmpeg -i "$video_file" "$mp4_file"

        rm "$video_file"

        echo "Converted: $video_file to $mp4_file"
    done
done

sizeafter=$(du -ms | awk '{print $1}')
declare -i A=("$sizebefore"-"$sizeafter")
echo "$A" MB have been freed!
