#!/bin/env bash

if [ -z "$WALLPAPERS" ]; then
  source "$HOME/.env"
fi

function get_wallpaper() {
  export album=$(ls $WALLPAPERS | fzf --prompt "Select an album")
  nsxiv -t $WALLPAPERS/$album
}

get_wallpaper
