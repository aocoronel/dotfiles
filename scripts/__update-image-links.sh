#!/usr/bin/env sh

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__update-image-links.sh

find . -name '*.md' -exec grep -lE '\.jpg|\.png|\.webp' {} \; | while read -r file; do
  sed -i -E 's/\.jpg|\.png|\.webp/.avif/g' "$file"
  echo "$file" updated
done
