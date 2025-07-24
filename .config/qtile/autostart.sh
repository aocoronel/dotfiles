#!/usr/bin/env bash

picom --daemon &
redshift -P -O 3500 &
tmuxp load sxhkd -d

xargs xwallpaper --maximize <"$HOME/.config/wall"
