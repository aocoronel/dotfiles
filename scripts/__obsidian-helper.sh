#!/usr/bin/env bash

# "Run git command in all Obsidian vaults"

source "$HOME/.scriptenv"

function main() {
  command="$1"
  find "$OBSIDIAN" -mindepth 1 -maxdepth 1 -type d | while read -r vault; do
    if [ -d "$vault/.git" ]; then
      echo "Working on $vault"
      if [ "$command" == "commit" ]; then
        git -C "$vault" add .
        git -C "$vault" commit -a -m "$(date +%F)"
      elif [ "$command" == "" ]; then
        git -C "$vault" status
      else
        git -C "$vault" "$command"
      fi
      echo
    else
      if [ "$VERBOSE" = "true" ]; then
        echo "Vault: $vault. Not a Git repository."
        echo
      fi
      continue
    fi
  done
}

while getopts ":v" opt; do
  case "$opt" in
  v)
    VERBOSE=true
    ;;
  ?)
    echo "Error: Invalid option '-$OPTARG'" >&2
    exit 1
    ;;
  esac
done

shift $((OPTIND - 1))

main $@
