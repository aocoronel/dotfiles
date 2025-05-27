#!/usr/bin/env bash

# "Add and commit all changes to OBSIDIAN vaults"

source "$HOME/.scriptenv"

function git_action() {
  command="$1"
  find "$OBSIDIAN" -mindepth 1 -maxdepth 1 -type d | while read -r vault; do
    if [ -d "$vault/.git" ]; then
      if [ "$command" == "commit" ]; then
        git -C "$vault" add .
        git -C "$vault" commit -a -m "$(date +%F)"
      elif [ "$command" == "pull" ]; then
        git -C "$vault" pull
      elif [ "$command" == "push" ]; then
        git -C "$vault" push
      fi
      val=$?
      if [ "$val" -eq 0 ]; then
        echo "Vault: $vault. Success!"
      else
        echo "Vault: $vault. Error!"
      fi
    else
      echo "Vault: $vault. Not a Git repository."
    fi
  done
}

function main() {
  command=$1
  case "$command" in
  commit)
    git_action commit
    ;;
  push)
    git_action push
    ;;
  pull)
    git_action pull
    ;;
  esac
}

main $@
