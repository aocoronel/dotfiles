#!/bin/env bash

if [ -z "$WALLPAPERS" ]; then
  eval $(awk -F= '/^(WALLPAPERS)=/ {print "export " $1 "=" $2}' ~/.env)
fi

function get_wallpaper() {
  export album=$(ls $WALLPAPERS | fzf --prompt "Select an album")
  nsxiv -t $WALLPAPERS/$album
}

get_wallpaper
