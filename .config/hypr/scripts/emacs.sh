#!/usr/bin/env bash

# "Run arbritary commands to Emacs"

client_name="$1"
client_address=$(hyprctl clients -j | jq -r ".[] | select(.class == \"Emacs\") | .address")

if [ -n "$client_address" ]; then
  hyprctl dispatch focuswindow address:"$client_address"
  case "$client_name" in
  daily-note)
    emacsclient -r --eval "(progn (set-frame-parameter nil 'name \"$client_name\") (org-roam-dailies-capture-today))"
    ;;
  extra)
    emacsclient -c
    ;;
  esac
else
  emacs
fi
