#!/usr/bin/env bash

function get_urls() {
  lynx -dump "https://leta.mullvad.net/search?q=$query&engine=brave" | rg --no-line-number '  https://' | tr -d " "
}

function _rofi() {
  rofi -dmenu -i -no-levenshtein-sort -width 1000 "$@"
}

function get_input() {
  search=$(echo "" | _rofi -p "> " -mesg "Enter your Search")
  [[ -z $search ]] && exit 1

  query=$(echo "$search" | sed 's/ /+/')
}

function main() {
  get_input
  select=$(get_urls | _rofi -p "󰖟 ")
  xdg-open "$select"
}

main
