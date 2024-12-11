#!/usr/bin/env bash

picom --daemon &
autokey-gtk &
nm-applet &
redshift -P -O 4000 &

xargs xwallpaper --maximize < "$HOME/.config/wall"
