#!/bin/env bash

function help() {
cat << EOF
Open Daily Notes
Usage: $0 [option]
Available options:
-h, --help                            - Displays this message and exits
-o, --obsidian                        - Open daily note in Obsidian
-n, --nvim                            - Open daily note in nvim
-s, --select                          - Choose the desired predefined software
EOF
}

folder="$OBSIDIAN/OUROBOROS/Journals/Daily/"

daily=$(date +%F)

function obsidian_daily() {
  obsidian-cli open "$daily" --vault OUROBOROS
}

function nvim_daily() {
  ghostty -e nvim "$folder/$daily".md
}

function neovide_daily() {
  neovide "$folder/$daily".md
}

function rofi_select() {
  select=$(echo -e "obsidian\nneovim\nneovide" | rofi -dmenu)
  if [ "$select" = "neovim" ]; then
    nvim_daily
  elif [ "$select" = "obsidian" ]; then
    obsidian_daily
  elif [ "$select" = "neovide" ]; then
    neovide_daily
  else
    notify-send -u normal "An error occurred!"
  fi
}

if [ "$#" -eq 0 ]; then
    echo "Error: No arguments provided."
    help
    exit 0
fi

while [[ "$1" != "" ]]; do
    case "$1" in
        -h | --help)
            help
            exit 0
            ;;
        -o | --obsidian)
            obsidian_daily
            exit 0
            ;;
        -n | --nvim)
             nvim_daily
             exit 0
            ;;
        -ne | --neovide)
             nvim_daily
             exit 0
            ;;
        -s | --select)
             rofi_select
             exit 0
            ;;
    esac
done
