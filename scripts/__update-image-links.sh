#!/usr/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__update-image-links.sh

ft=${1:-md}

find . -name "*.$ft" -exec grep -lE '\.jpg|\.png|\.webp' {} \; | while read -r file; do
  sed -i -E 's/\.jpg|\.png|\.webp/.avif/g' "$file"
  echo "$file" updated
done
