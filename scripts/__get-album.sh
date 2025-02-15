#!/bin/env bash

if [ -z "$WALLPAPERS" ]; then
  var=$(grep "WALLPAPERS" "$HOME/.localenv")
  export $var
fi

function get_wallpaper() {
  export album=$(ls "$WALLPAPERS" | fzf --prompt "Select an album")
  swayimg --gallery "$WALLPAPERS/$album"
}

get_wallpaper
