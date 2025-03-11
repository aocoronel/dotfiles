#!/usr/bin/env bash

# https://github.com/user/dotfiles/blob/main/scripts/__flashcards.sh

if ! command -v mdfc &>/dev/null; then
  echo "mdfc could not be found. Please install it."
  exit 1
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/lib/get_env.sh"

get_flashcard # Get FLASHCARD env

if [ -z "$FLASHCARD" ]; then
  echo "Error: FLASHCARD env at .localenv not found"
  exit 1
fi

FLASH_DIR=$(dirname "$FLASHCARD")
FLASH_FILE=$FLASHCARD
NOW=$(date +%F)

if [ ! -f "$FLASH_FILE" ]; then
  echo "$FLASHCARD"
  echo "$FLASH_FILE"
  echo "Flashcard not found!"
  exit 1
fi

function flash_state() {
  du --bytes "$FLASH_FILE" | awk '{print $1}'
}

function commit() {
  git -C "$FLASH_DIR" add flashcards.md &&
    git -C "$FLASH_DIR" commit flashcards.md -m "flashcard: update $NOW"
  return 0
}

function main() {
  INITIAL_STATE=$(flash_state)
  mdfc -o -w 100 "$FLASH_FILE"
  CURRENT_STATE=$(flash_state)

  if [ "$CURRENT_STATE" -ne "$INITIAL_STATE" ]; then
    commit
  fi
}

main
