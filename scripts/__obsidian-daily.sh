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

folder=Journals/Daily/

Year=$(date +%Y)
Month=$(date +%B)
Day=$(date +%d)

if [ $Day -eq 1 ]; then
  OrdinalSuffix="st"
elif [ $Day -eq 2 ]; then
  OrdinalSuffix="nd"
elif [ $Day -eq 3 ]; then
  OrdinalSuffix="rd"
elif [ ${#Day} -gt 1 ] && [ ${Day: -2} -eq 11 ]; then
  OrdinalSuffix="th"
elif [ ${#Day} -gt 1 ] && [ ${Day: -2} -eq 12 ]; then
  OrdinalSuffix="th"
elif [ ${#Day} -gt 1 ] && [ ${Day: -2} -eq 13 ]; then
  OrdinalSuffix="th"
elif [ ${#Day} -gt 1 ] && [ ${Day: -2} -eq 21 ]; then
  OrdinalSuffix="st"
elif [ ${#Day} -gt 1 ] && [ ${Day: -2} -eq 22 ]; then
  OrdinalSuffix="nd"
elif [ ${#Day} -gt 1 ] && [ ${Day: -2} -eq 23 ]; then
  OrdinalSuffix="rd"
elif [ ${#Day} -gt 1 ] && [ ${Day: -2} -eq 31 ]; then
  OrdinalSuffix="st"
else
  OrdinalSuffix="th"
fi

daily=$(echo "${Month} ${Day}${OrdinalSuffix}, ${Year}")

function obsidian_daily() {
  obsidian-cli open "$daily" --vault OUROBOROS
}

function nvim_daily() {
  kitty -e nvim "$OBSIDIAN/OUROBOROS/$folder/$daily".md
}

function rofi_select() {
  select=$(echo -e "nvim\nobsidian" | rofi -dmenu)
  if [ "$select" = "nvim" ]; then
    nvim_daily
  elif [ "$select" = "obsidian" ]; then
    obsidian_daily
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
        -s | --select)
             rofi_select
             exit 0
            ;;
    esac
done
