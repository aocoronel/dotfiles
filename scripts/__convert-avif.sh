#!/bin/env bash

find . $ -iname '*.jpg' -o -iname '*.png' -o -iname '*.webp' $ -exec sh -c '
  for img; do
    magick -verbose "$img" "${img%.*}.avif" && rm "$img"
  done
' _ {} +
