#!/bin/sh

# export XDG_RUNTIME_DIR=/run/user/$(id -u)
export XDG_SESSION_TYPE=x11

# Start D-Bus if not running already
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

dbus-update-activation-environment --all &

# Blue Light Filter
redshift -P -O 4000 &

xrandr --output HDMI1 --mode 1920x1080 &

# Increase input rate
xset r rate 225 35 &

# sxhkd &

# Set Wallpaper
xwallpaper --maximize "$HOME/stow/swaybg-wallpaper.jpg" &

init_wallpaper &
setup_bindings() {
  setxkbmap -layout us,br -option grp:switch,ctrl:nocaps
}

setup_bindings &

dbus-launch ssh-agent i3
