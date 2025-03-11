#!/bin/env bash

# Environment Variables are sourced from .localenv at $HOME
# Example:
# https://github.com/aocoronel/dotfiles/blob/main/.localenv-template

get_term() {
  if [ -z "$TERMCMD" ]; then
    terminal=$(grep "^TERMCMD=" "$HOME/.localenv" | cut -d '=' -f2-)
    export TERMCMD=$terminal
  fi
}
