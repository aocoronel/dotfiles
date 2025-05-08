#!/usr/bin/env bash

# Originally created by Piotr1215
# Find the original config here:
# https://github.com/Piotr1215/dotfiles/blob/master/.config/taskwarrior-tui/shortcut-scripts/__annotate_with_new_note.sh

# UUID of the task to annotate
uuid="$1"

# Directory where notes are stored
notes_dir="$HOME/obsidian/OUROBOROS/"
templates_dir="$notes_dir/templates/"

# Prompt for the new note name
read -p "Enter the name for the new note: " new_note_name
copy_note="$templates_dir/Atomic - Template.md"
filepath="$notes_dir/$new_note_name.md"

# Check if file with this name already exists
if [ -f "$filepath" ]; then
  echo "File with this name already exists. Annotating the task with the existing note."
else
  nvim -n -c "ObsidianNew $new_note_name" --headless >/dev/null 2>&1 &
  cp "$copy_note" "$filepath"
  echo "New note created and opened in Neovim."
fi

# Annotate the task with the filepath
task_output=$(task rc.bukl=0 rc.confirmation=off "$uuid" annotate "nvimline:1:$filepath")

# Check if annotation was successful
if [[ "$task_output" == *"Annotated"* ]]; then
  echo "Successfully annotated the task with the note."
else
  echo "Failed to annotate the task."
fi

nvim "$filepath"
