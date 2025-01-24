#!/bin/env bash

sizebefore_mb=$(du -ms | awk '{print $1}')
sizebefore_kb=$(du -ks | awk '{print $1}')

imageformats=("jpg" "png" "webp" "jpeg")

for format in "${imageformats[@]}"; do
    find . -type f -iname "*.$format" | while read -r image_file; do
        avif_file="${image_file%.$format}.avif"

        magick "$image_file" "$avif_file"

        rm "$image_file"

        echo "Converted: $image_file to $avif_file"
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
