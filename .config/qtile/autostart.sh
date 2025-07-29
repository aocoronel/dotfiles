#!/usr/bin/env bash

export XDG_SESSION_TYPE=x11

exec pipewire &

# Blue Light Filter
exec redshift -P -O 3500 &

# Increase input rate
exec xset r rate 250 35 &

# Composer
exec picom --daemon &

# Sxhkd and Clip servers
exec tmux kill-session -t sxhkd &
exec tmuxp load sxhkd -d &
exec tmux kill-session -t clip &
exec tmuxp load clip -d &

# Wallpaper
exec xargs xwallpaper --maximize <"$HOME/.config/wall" &

# Gnome Keyring
exec gnome-keyring-daemon --start --components=secrets &

# Dbus
exec dbus-update-activation-environment --all &

# Taskwarrior Notifications
exec sh "$HOME/scripts/__task-notify.sh" &
exec taskchampion-sync-server --listen 192.168.0.35:8080 --allow-client-id 6b00cabe-4e17-405f-878b-5b61a99cf326 -d /home/aocoronel/.taskchampion &

exec dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita'" &
exec dconf write /org/gnome/desktop/interface/icon-theme "'Flat-Remix-Red-Dark'" &
exec dconf write /org/gnome/desktop/interface/document-font-name "'Noto Sans Medium 11'" &
exec dconf write /org/gnome/desktop/interface/font-name "'Noto Sans Medium 11'" &
exec dconf write /org/gnome/desktop/interface/monospace-font-name "'Noto Sans Mono Medium 11'" &

function initiliaze_qtile() {
  dbus-launch qtile start
}

function initialize_dwm() {
  new_csum=$(sha1sum "$(which dwm)")
  while true; do
    if [ "$csum" != "$new_csum" ]; then
      csum=$new_csum
      dbus-launch ssh-agent dwm
    else
      exit 0
    fi
    new_csum=$(sha1sum "$(which dwm)")
    sleep 0.5
  done
}

# Choose one

initialize_dwm
# initiliaze_qtile
