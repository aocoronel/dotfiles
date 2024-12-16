#!/usr/bin/env bash

picom --daemon &
nm-applet &
redshift -P -O 4000 &
tmuxp load key -d

xargs xwallpaper --maximize < "$HOME/.config/wall"
