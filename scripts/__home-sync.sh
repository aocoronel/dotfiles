#!/usr/bin/env sh

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__home-sync.sh

function main() {
  if [ ! -d "$HOME/home" ]; then
    echo "Please, create a new directory at:"
    echo "$HOME/home"
  fi
  rsync --progress -avh --delete --exclude-from=$HOME/.rsync-ignore "$HOME/" "$HOME/home/"
}

main
