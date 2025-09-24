#!/bin/bash

SNIPPET_DIR="$HOME/.config/helix/snippets/"

file=$(find "$SNIPPET_DIR" -type f | sed "s|$SNIPPET_DIR||" | fzf)
cat "$HOME/.config/helix/snippets/$file"
