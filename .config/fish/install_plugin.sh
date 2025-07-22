#!/usr/bin/env bash

set -euo pipefail

function install_fzf() {
  REPO_DIR="$HOME/.config/fish/plugins/fzf.fish"
  git clone --depth=1 "https://github.com/jethrokuan/fzf" "$REPO_DIR"

  mkdir -p "$HOME/.config/fish/functions"
  mkdir -p "$HOME/.config/fish/conf.d"

  for dir in functions conf.d; do
    [[ ! -d "$REPO_DIR/$dir" ]] && mkdir -p "$HOME/.config/fish/$dir"
    for file in "$REPO_DIR/$dir/"*; do
      ln -sf "$file" "$HOME/.config/fish/$dir/$(basename "$file")"
    done
  done
  echo "SETUVAR FZF_COMPLETE:2" >>"$REPO_DIR/fish_variables"
}

function main() {
  install_fzf
}

main
