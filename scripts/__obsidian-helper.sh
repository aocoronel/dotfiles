#!/usr/bin/env bash

# "Run git command in all Obsidian vaults"

source "$HOME/.scriptenv"

function main() {
  command="$1"
  find "$OBSIDIAN" -mindepth 1 -maxdepth 1 -type d | while read -r vault; do
    echo "Working on $vault"
    if [ -d "$vault/.git" ]; then
      if [ "$command" == "commit" ]; then
        git -C "$vault" add .
        git -C "$vault" commit -a -m "$(date +%F)"
      else
        git -C "$vault" "$command"
      fi
    else
      echo "Vault: $vault. Not a Git repository."
    fi
  done
}

main $@
