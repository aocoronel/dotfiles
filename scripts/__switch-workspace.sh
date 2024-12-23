#!/bin/env bash

function switch_workspace() {
  choose=$(ls $OBSIDIAN | rofi -dmenu)
  echo "$OBSIDIAN/$choose" > "$HOME/.config/obsidian-workspace.conf"
}

switch_workspace
