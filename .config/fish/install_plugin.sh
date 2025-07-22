#!/usr/bin/env bash

FZF_REPO="$HOME/.config/fish/plugins/fzf.fish"
TRANSIENT_REPO="$HOME/.config/fish/plugins/transient.fish"
COMMAND=$1

function install_fzf() {
  git clone --depth=1 "https://github.com/jethrokuan/fzf" "$FZF_REPO"

  mkdir -p "$HOME/.config/fish/functions"
  mkdir -p "$HOME/.config/fish/conf.d"

  for dir in functions conf.d; do
    [[ ! -d "$FZF_REPO/$dir" ]] && mkdir -p "$HOME/.config/fish/$dir"
    for file in "$FZF_REPO/$dir/"*; do
      ln -sf "$file" "$HOME/.config/fish/$dir/$(basename "$file")"
    done
  done
  echo "SETUVAR FZF_COMPLETE:0" >>"$FZF_REPO/fish_variables"
}

function install_transient() {
  git clone --depth=1 https://github.com/zzhaolei/transient.fish "$TRANSIENT_REPO"

  for dir in functions conf.d; do
    [[ ! -d "$TRANSIENT_REPO/$dir" ]] && mkdir -p "$HOME/.config/fish/$dir"
    for file in "$TRANSIENT_REPO/$dir/"*; do
      ln -sf "$file" "$HOME/.config/fish/$dir/$(basename "$file")"
    done
  done
}

function update() {
  git -C "$FZF_REPO" pull
  git -C "$TRANSIENT_REPO" pull
}

function main() {
  [[ ! -d "$FZF_REPO" ]] && install_fzf
  [[ ! -d "$TRANSIENT_REPO" ]] && install_transient
}

case "$COMMAND" in
fzf)
  install_fzf
  ;;
transient)
  install_transient
  ;;
update)
  update
  ;;
esac

main
