#!/usr/bin/env bash 

COLORSCHEME=ElegantVagrant

picom --daemon &
autokey-gtk &
nm-applet &

xargs xwallpaper --maximize < ~/.config/wall
