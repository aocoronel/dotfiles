#!/bin/env bash

if [ -z "$APPS" ]; then
  source "$HOME/.env"
fi

cd "$APPS"

choice=$(find . -type f -iname "*.AppImage" | rofi -dmenu)

if [ "$choice" = "anki" ]; then
  ./anki/anki
elif [ "$choice" = "zotero" ]; then
  ./Zotero_linux-x86_64/zotero
else
  ./"$choice"
fi
