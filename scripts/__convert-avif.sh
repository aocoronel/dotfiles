#!/usr/bin/env sh

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__convert-avif.sh

if ! command -v magick &>/dev/null; then
  echo "imagemagick could not be found. Please install it."
  exit 1
fi

function get_mb() {
  du -ms | awk '{print $1}'
}

function get_kb() {
  du -ks | awk '{print $1}'
}

sizebefore_mb=$(get_mb)
sizebefore_kb=$(get_kb)

imageformats=("jpg" "png" "webp" "jpeg")

for format in "${imageformats[@]}"; do
  find . -type f -iname "*.$format" | while read -r image_file; do
    avif_file="${image_file%.$format}.avif"

    magick "$image_file" "$avif_file"

    rm "$image_file"

    echo "Converted: $image_file to $avif_file"
  done
done

sizeafter_mb=$(get_mb)
declare -i A=("$sizebefore_mb"-"$sizeafter_mb")

if [ "$A" -eq 0 ]; then
  sizeafter_kb=$(get_kb)
  declare -i B=("$sizebefore_kb"-"$sizeafter_kb")
  echo "$B" KB have been freed!
else
  echo "$A" MB have been freed!
fi
