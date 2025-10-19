#!/usr/bin/env sh

set +e

swww-daemon >/dev/null 2>&1

[ ! -f "$HOME/.cache/swww-wallpaper.jpg" ] && sh ~/.config/hypr/scripts/swww.sh >/dev/null 2>&1

gnome-keyring-daemon --start --components=secrets >/dev/null 2>&1
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 || /usr/libexec/polkit-gnome-authentication-agent-1 >/dev/null 2>&1
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots >/dev/null 2>&1
sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP >/dev/null 2>&1
waybar >/dev/null 2>&1
wl-paste --type text --watch cliphist store >/dev/null 2>&1
wl-paste --type image --watch cliphist store >/dev/null 2>&1
dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita'" >/dev/null 2>&1
dconf write /org/gnome/desktop/interface/icon-theme "'Flat-Remix-Red-Dark'" >/dev/null 2>&1
dconf write /org/gnome/desktop/interface/document-font-name "'Noto Sans Medium 11'" >/dev/null 2>&1
dconf write /org/gnome/desktop/interface/font-name "'Noto Sans Medium 11'" >/dev/null 2>&1
dconf write /org/gnome/desktop/interface/monospace-font-name "'Noto Sans Mono Medium 11'" >/dev/null 2>&1

# wlsunset -T 3501 -t 3500 >/dev/null 2>&1 &
