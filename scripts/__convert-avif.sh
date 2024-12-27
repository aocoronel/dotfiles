#!/bin/env bash

sizebefore=$(du -ms | awk '{print $1}')

imageformats=("jpg" "png" "webp")

for format in "${imageformats[@]}"; do
    find . -type f -iname "*.$format" | while read -r image_file; do
        avif_file="${image_file%.$format}.avif"

        magick "$image_file" "$avif_file"

        rm "$image_file"

        echo "Converted: $image_file to $avif_file"
    done
done

sizeafter=$(du -ms | awk '{print $1}')
declare -i A=("$sizebefore"-"$sizeafter")
echo "$A" MB have been freed!
