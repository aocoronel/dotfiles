#!/bin/env bash

imageformats=("jpg" "png" "webp")

for format in "${imageformats[@]}"; do
    find . -type f -iname "*.$format" | while read -r image_file; do
        avif_file="${image_file%.$format}.avif"

        magick "$image_file" "$avif_file"

        rm "$image_file"

        echo "Converted: $image_file to $avif_file"
    done
done
