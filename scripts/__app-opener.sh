#!/bin/env bash

cd "$APPS"

case "$1" in
  "y")
    ./app-freetube.AppImage
    ;;
  "df")
    ./app-desktop-filen.AppImage
    ;;
  "cf")
    ./app-cli-filen.AppImage
    ;;
  "e")
    ./app-ente.AppImage
    ;;
  "a")
    ./anki/anki
    ;;
  "z")
    ./Zotero_linux-x86_65/zotero
    ;;
esac
