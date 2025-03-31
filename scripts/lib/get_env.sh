#!/usr/bin/env sh

# Environment Variables are sourced from .localenv at $HOME
# Example:
# https://github.com/aocoronel/dotfiles/blob/main/.localenv-template

LOCALENV="$HOME/.localenv"

if [ -z "$LOCALENV" ]; then
  echo ".localenv is missing at $HOME!"
  return 1
fi

function get_term() {
  if [ -z "$TERMCMD" ]; then
    local env
    env=$(grep "^TERMCMD=" "$LOCALENV" | cut -d '=' -f2-)
    local val=$?
    if [ "$val" -ne 0 ]; then
      echo "TERMCMD not found in .localenv"
      return 1
    fi
    export TERMCMD=$env
  fi
}

function get_obsidian() {
  if [ -z "$OBSIDIAN" ]; then
    local env
    env=$(grep "^OBSIDIAN=" "$LOCALENV" | cut -d '=' -f2-)
    local val=$?
    if [ "$val" -ne 0 ]; then
      echo "OBSIDIAN not found in .localenv"
      return 1
    fi
    export OBSIDIAN=$env
  fi
}

function get_flashcard() {
  if [ -z "$FLASHCARD" ]; then
    local env
    env=$(grep "^FLASHCARD=" "$LOCALENV" | cut -d '=' -f2-)
    local val=$?
    if [ "$val" -ne 0 ]; then
      echo "FLASHCARD not found in .localenv"
      return 1
    fi
    export FLASHCARD=$env
  fi
}

function get_journal() {
  if [ -z "$JOURNAL" ]; then
    local env
    env=$(grep "^JOURNAL=" "$LOCALENV" | cut -d '=' -f2-)
    local val=$?
    if [ "$val" -ne 0 ]; then
      echo "JOURNAL not found in .localenv"
      return 1
    fi
    export JOURNAL=$env
  fi
}

function get_wallpapers() {
  if [ -z "$WALLPAPERS" ]; then
    local env
    env=$(grep "^WALLPAPERS=" "$LOCALENV" | cut -d '=' -f2-)
    local val=$?
    if [ "$val" -ne 0 ]; then
      echo "WALLPAPERS not found in .localenv"
      return 1
    fi
    export WALLPAPERS=$env
  fi
}

function get_dev() {
  if [ -z "$DEV" ]; then
    local env
    env=$(grep "^DEV=" "$LOCALENV" | cut -d '=' -f2-)
    local val=$?
    if [ "$val" -ne 0 ]; then
      echo "DEV not found in .localenv"
      return 1
    fi
    export DEV=$env
  fi
}

function get_music() {
  if [ -z "$MUSIC" ]; then
    local env
    env=$(grep "^MUSIC=" "$LOCALENV" | cut -d '=' -f2-)
    local val=$?
    if [ "$val" -ne 0 ]; then
      echo "MUSIC not found in .localenv"
      return 1
    fi
    export MUSIC=$env
  fi
}

function get_vault() {
  if [ -z "$VAULT" ]; then
    local env
    env=$(grep "^VAULT=" "$LOCALENV" | cut -d '=' -f2-)
    local val=$?
    if [ "$val" -ne 0 ]; then
      echo "VAULT not found in .localenv"
      return 1
    fi
    export VAULT=$env
  fi
}

function get_scripts() {
  if [ -z "$SCRIPTS" ]; then
    local env
    env=$(grep "^SCRIPTS=" "$LOCALENV" | cut -d '=' -f2-)
    local val=$?
    if [ "$val" -ne 0 ]; then
      echo "SCRIPTS not found in .localenv"
      return 1
    fi
    export SCRIPTS=$env
  fi
}

function get_editor() {
  if [ -z "$EDITOR" ]; then
    local env
    env=$(grep "^EDITOR=" "$LOCALENV" | cut -d '=' -f2-)
    local val=$?
    if [ "$val" -ne 0 ]; then
      echo "EDITOR not found in .localenv"
      return 1
    fi
    export EDITOR=$env
  fi
}
