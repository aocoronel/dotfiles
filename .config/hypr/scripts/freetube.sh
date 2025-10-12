#!/usr/bin/env bash

invidious_config="$HOME/invidious/"

function startup() {
  if podman ps | grep -q "invidious"; then
    echo "Invidious Instance is already running."
    notify-send "Invidious Instance is already running."
  else
    cd "$invidious_config" || {
      notify-send -u critical "Invidious" "An error occurred"
      exit 1
    }
    podman-compose up -d
    echo "Invidious Instance launched."
    notify-send "Invidious Instance launched."
    sleep 5
  fi
}

function main() {
  mode="$1"
  if [ "$mode" == "flatpak" ]; then
    freetube_cmd="io.freetubeapp.FreeTube"
  else
    freetube_cmd="freetube"
  fi
  startup
  pgrep $freetube_cmd && hyprctl dispatch focuswindow class:$freetube_cmd || setsid -f $freetube_cmd
}

main "$@"
