#!/usr/bin/env bash

# "Show all Hyprland Keybindings"

function _rofi() {
  rofi -dmenu -i -no-levenshtein-sort -width 1000
}

rg "^bind" <"$HOME/.config/hypr/modules/keybinds.conf" | sed "s/^[^=]*=//; s/exec,[^#]*#/#/" | _rofi
