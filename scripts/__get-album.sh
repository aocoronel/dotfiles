#!/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__get-album.sh

if [ -z "$WALLPAPERS" ]; then
  var=$(grep "WALLPAPERS" "$HOME/.localenv")
  export $var
fi

function get_wallpaper() {
  export album=$(ls "$WALLPAPERS" | fzf --prompt "Select an album")
  swayimg --gallery "$WALLPAPERS/$album"
}

get_wallpaper
