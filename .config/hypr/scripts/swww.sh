#!/usr/bin/env bash

set -euo pipefail

if swww query | grep "image"; then
  exit 0
fi

IMG_URL="https://wallpapercave.com/wp/wp11858477.jpg"
EXPECTED_HASH="dc79b999b0f6e645ad4a94952456812809cce448917e412be5fd87e07a80c41914b969bd0d06889d003c1d07a863d84a9dab8dd8f6fe003c591395f9fd3fce2b"

CACHE_DIR="$HOME/.cache"
OUT_FILE="$CACHE_DIR/swww-wallpaper.jpg"
TMP_FILE="$(mktemp)"

if [ -f "$OUT_FILE" ]; then
  exit 0
fi

mkdir -p "$CACHE_DIR"

wget "$IMG_URL" -O "$TMP_FILE"

ACTUAL_HASH=$(sha512sum "$TMP_FILE" | awk '{print $1}')

if [[ "$ACTUAL_HASH" != "$EXPECTED_HASH" ]]; then
  echo "❌ SHA512 mismatch! Aborting."
  echo "Expected: $EXPECTED_HASH"
  echo "Actual:   $ACTUAL_HASH"
  rm -f "$TMP_FILE"
  exit 1
fi

mv "$TMP_FILE" "$OUT_FILE"

swww img --transition-type=fade "$OUT_FILE"
