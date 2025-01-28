#!/bin/env bash

tmux=false

function tskd() {
  if [[ ${1:0:1} =~ [0-9] ]]; then
    # Format: 2025 01 01
    year=$1
    month=$2
    day=$3
    date="$year-$month-$day"
    next_day=$(date -d "$date + 1 day" '+%F')
    task end.after:$date and end.before:$next_day completed
  else
    # Format: August\ 10th,\ 2024.md
    if [ "$tmux" = true ]; then
      raw_date=$(basename -- "$1")
    else
      raw_date="$1"
    fi
    polish_date=$(echo "$raw_date" | sed 's/\.md//; s/th//')
    date=$(date -d "$polish_date" '+%Y-%m-%d')
    next_day=$(date -d "$date + 1 day" '+%F')
    if [ "$tmux" = true ]; then
      task end.after:$date and end.before:$next_day completed
      sleep 5
    else
      task end.after:$date and end.before:$next_day completed
    fi
  fi
}

case "$2" in
  "tmux")
    tmux=true
    ;;
esac

tskd "$1" "$2"
