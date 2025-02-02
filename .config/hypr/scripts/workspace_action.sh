#!/usr/bin/env bash

# Author: end-4
# Github: https://github.com/end-4/dots-hyprland

hyprctl dispatch "$1" $(((($(hyprctl activeworkspace -j | jq -r .id) - 1) / 10) * 10 + $2))
