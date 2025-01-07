#!/bin/env bash

editor="$EDITOR"

function help() {
  echo "Home dotfiles unsync file finder"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "all                      - Looks for unsynced files in all folders"
  echo "help                     - Displays this message and exits"
}

home="$SCRIPTS/rsync/rsync-home.txt"
config="$SCRIPTS/rsync/rsync-config.txt"
local="$SCRIPTS/rsync/rsync-local.txt"
ignore_file="$SCRIPTS/rsync/.ignore.txt"

home_saved=$(fd . -H --max-depth 1 "$HOME" | awk -F"$HOME/" '{print $2}')
config_saved=$(fd . -H --max-depth 1 "$HOME/.config/" | awk -F"$HOME/.config/" '{print $2}')
local_saved=$(fd . -H --max-depth 1 "$HOME/.local/share/" | awk -F"$HOME/.local/share/" '{print $2}')

function update() {
  read -p "Choose a directory (home/config/local): " choice
  if [ "$choice" == "home" ]; then
    dir_files="$home_saved"
    saved_file="$home"
  elif [ "$choice" == "config" ]; then
    dir_files="$config_saved"
    saved_file="$config"
  elif [ "$choice" == "local" ]; then
    dir_files="$local_saved"
    saved_file="$local"
  else
    echo "Invalid choice!"
    return 1
  fi
  echo "Looking for unsynced files in $choice..."
  apply_ignore_patch=$(comm -23 <(echo "$dir_files" | sort) <(cat "$ignore_file" | sort))
  unsynced_files=$(comm -23 <(echo "$apply_ignore_patch" | sort) <(cat "$saved_file" | sort))
  if [ -z "$unsynced_files" ]; then
    echo "Everything is up to date!"
    return 0
  fi
  echo "Unsynced files:"
  echo "$unsynced_files"
}

function all() {
  declare -A dirs
  dirs=( ["home"]="$home_saved" ["config"]="$config_saved" ["local"]="$local_saved" )
  declare -A files
  files=( ["home"]="$home" ["config"]="$config" ["local"]="$local" )
  for dir in "${!dirs[@]}"
  do
    echo "Checking unsynced files in $dir..."
    dir_files="${dirs[$dir]}"
    saved_file="${files[$dir]}"
    apply_ignore_patch=$(comm -23 <(echo "$dir_files" | sort) <(cat "$ignore_file" | sort))
    unsynced_files=$(comm -23 <(echo "$apply_ignore_patch" | sort) <(cat "$saved_file" | sort))
    if [ -z "$unsynced_files" ]; then
      echo "Everything is up to date in $dir!"
    else
      echo "Unsynced files in $dir:"
      echo "$unsynced_files"
    fi
  done
}

function ignore() {
  "$editor" "$HOME/scripts/rsync/.ignore.txt"
}

case "$1" in
  "")
    update
    ;;
  "all")
    all
    ;;
  "ignore")
    ignore
    ;;
  "help")
    help
    ;;
esac
