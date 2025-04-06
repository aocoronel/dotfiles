#!/usr/bin/env bash

# Originally created by Piotr1215
# Find the original config here:
# https://github.com/Piotr1215/dotfiles/blob/master/.config/taskwarrior-tui/shortcut-scripts/__annotate_with_note.sh

# UUID of the task to annotate
uuid="$@"

# Base directory where notes are stored
notes_dir="$HOME/org/"

# Array of subdirectories to search in
subdirs=("personal.p" "roam")

# Find files in the specified subdirectories and show fzf dialog to select an existing note
filepath=$(find "${subdirs[@]/#/$notes_dir}" -type f -name '*.org' | fzf-tmux --preview "bat --color=always {}")

# If fzf was cancelled, exit the script
if [ -z "$filepath" ]; then
  echo "No file selected. Exiting."
  exit 1
fi

# Annotate the task with the selected filepath
task_output=$(task rc.bulk=0 rc.confirmation=off "$uuid" annotate "nvimline:1:$filepath")

# Check if annotation was successful
if [[ "$task_output" == *"Annotated"* ]]; then
  echo "Successfully annotated the task with the note."
else
  echo "Failed to annotate the task."
fi

# Open the selected note in nvim
nvim "$filepath"
