#!/usr/bin/env sh

set +e

waybar >/dev/null &
swww-daemon >/dev/null &
hypridle >/dev/null &

[ ! -f "$HOME/.cache/swww-wallpaper.jpg" ] && sh ~/.config/hypr/scripts/swww.sh >/dev/null &

gnome-keyring-daemon --start --components=secrets >/dev/null &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 >/dev/null & || /usr/libexec/polkit-gnome-authentication-agent-1 >/dev/null &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots >/dev/null &
sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP >/dev/null &
wl-paste --type text --watch cliphist store >/dev/null &
wl-paste --type image --watch cliphist store >/dev/null &
dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita'" >/dev/null &
dconf write /org/gnome/desktop/interface/icon-theme "'Flat-Remix-Red-Dark'" >/dev/null &
dconf write /org/gnome/desktop/interface/document-font-name "'Noto Sans Medium 11'" >/dev/null &
dconf write /org/gnome/desktop/interface/font-name "'Noto Sans Medium 11'" >/dev/null &
dconf write /org/gnome/desktop/interface/monospace-font-name "'Noto Sans Mono Medium 11'" >/dev/null &

# wlsunset -T 3501 -t 3500 >/dev/null 2>&1 &
