#!/usr/bin/env bash

mode=$1
shift
args=$*
restart="Alt-r"

function get_urls() {
  lynx -dump "https://leta.mullvad.net/search?q=$query&engine=brave" | rg --no-line-number '  https://' | tr -d " "
}

function _rofi() {
  rofi -dmenu -i -no-levenshtein-sort -width 1000 -kb-custom-1 "${restart}" "$@"
}

function get_input() {
  if [ "$mode" == "sh" ]; then
    search=$args
    echo "$search"
  else
    search=$(echo "" | _rofi -p "> " -mesg "Enter your Search: ")
  fi
  [[ -z $search ]] && exit 1
  query=$(echo "$search" | sed 's/ /+/')
}

function main() {
  get_input
  if [ "$mode" == "sh" ]; then
    select=$(get_urls | fzf)
  else
    select=$(get_urls | _rofi -p "󰖟 ")
  fi
  val=$?
  case "$val" in
  10)
    main
    ;;
  esac
  if [ "$mode" == "sh" ]; then
  [[ -z $select ]] && exit 1
    lynx -cookies $select
  else
    xdg-open "$select" >/dev/null
  fi
}

main
