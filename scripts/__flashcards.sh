#!/bin/env bash

FLASH_DIR="$OBSIDIAN/OUROBOROS/"
FLASH_FILE="$FLASH_DIR/flashcards.md"
NOW=$(date +%F)

if [ ! -f "$FLASH_FILE" ]; then
  echo "Flashcard not found!"
  sleep 1
  return 1
fi

function flash_state() {
  du --bytes "$FLASH_FILE" | awk '{print $1}'
}

function commit() {
  git -C "$FLASH_DIR" add flashcards.md &&
    git -C "$FLASH_DIR" commit flashcards.md -m "flashcard: update $NOW"
  return 0
}

function flash() {
  INITIAL_STATE=$(flash_state)
  mdfc -o -w 100 "$FLASH_FILE"
  CURRENT_STATE=$(flash_state)

  if [ "$CURRENT_STATE" -ne "$INITIAL_STATE" ]; then
    commit
  fi
}

flash
