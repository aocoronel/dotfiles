#!/usr/bin/env sh

if [ -z "$VAULT" ]; then
  source "$HOME/.env"
fi

function clipper() {
  export pass=$(ls $VAULT | grep ".asc" | fzf --height 40% --prompt "Select pgp file to output: ")
  if [ ! -f "$pass" ]; then
    echo "Exitting..."
    exit 1
  fi
  gpg --decrypt $VAULT/$pass | xsel --clipboard --input --selectionTimeout 10000
}

clipper
