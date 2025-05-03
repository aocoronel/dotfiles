#!/usr/bin/env bash

# "Allows to cycle between same applications"
# Example: Cycle Two Firefox Browsers

active_class=$(hyprctl activewindow -j | jq -r '.class')

mapfile -t windows < <(hyprctl clients -j | jq -r ".[] | select(.class == \"$active_class\") | .address")

current_window=$(hyprctl activewindow -j | jq -r '.address')
echo "Current window: $current_window"

for i in "${!windows[@]}"; do
  if [[ "${windows[i]}" == "$current_window" ]]; then
    next_index=$(((i + 1) % ${#windows[@]}))
    next_window=${windows[next_index]}
    hyprctl dispatch focuswindow address:"$next_window"
    exit
  fi
done
