#!/usr/bin/env sh

set +e

waybar >/dev/null &
swww-daemon >/dev/null &
hypridle >/dev/null &

gnome-keyring-daemon --start --components=secrets >/dev/null &
# /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 >/dev/null & || /usr/libexec/polkit-gnome-authentication-agent-1 >/dev/null &

# wlsunset -T 3501 -t 3500 >/dev/null 2>&1 &

[ ! -f "$HOME/.cache/swww-wallpaper.jpg" ] && sh ~/.config/hypr/scripts/swww.sh >/dev/null &
