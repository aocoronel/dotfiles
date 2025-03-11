#!/bin/env bash

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
    terminal=$(grep "^TERMCMD=" "$LOCALENV" | cut -d '=' -f2-)
    export TERMCMD=$terminal
  fi
}
