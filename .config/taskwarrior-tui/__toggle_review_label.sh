#!/usr/bin/env bash

# Originally created by Piotr1215
# Find the original config here:
# https://github.com/Piotr1215/dotfiles/blob/master/.config/taskwarrior-tui/shortcut-scripts/__toggle_review_label.sh

uuid="$1"
# Use task _tags command to get current tags
current_tags=$(task _tags "$uuid")

if echo "$current_tags" | grep -q "review"; then
  # Remove review tag if present
  task rc.bulk=0 rc.confirmation=off "$uuid" modify -review
else
  # Add review tag if not present
  task rc.bulk=0 rc.confirmation=off "$uuid" modify +review
fi
