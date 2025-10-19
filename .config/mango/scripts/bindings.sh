#!/usr/bin/env bash

# "Show all Mango Keybindings"

function _rofi() {
  rofi -dmenu -i -no-levenshtein-sort -width 1000
}

rg "^bind" <"$HOME/.config/mango/bindings.conf" | rg -v "IGNORE" | sed "s/^[^=]*=//; s/exec,[^#]*#/#/" | _rofi
