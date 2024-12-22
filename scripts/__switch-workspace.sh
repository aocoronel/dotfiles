#!/bin/env bash

choose=$(ls $OBSIDIAN | rofi -dmenu)
echo "$OBSIDIAN/$choose" > "$HOME/.config/obsidian-workspace.conf"
