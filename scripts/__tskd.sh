#!/bin/env bash

tmux=false

month_list="January
February
March
April
May
June
July
August
September
October
November
December"

function tskd() {
  local start_date=""
  local end_date=""

  case "$1" in
  *-W[0-9][0-9]) # Matches YYYY-WXX
    year=${1:0:4}
    week=$(echo "$1" | sed 's/.*-W//')
    week=$(printf "%02d" "$week" &>/dev/null)
    start_date=$(date -d "$year +$(((week) * 7)) days" '+%F')
    end_date=$(date -d "$start_date +7 days" '+%F')
    ;;
  [0-9][0-9][0-9][0-9]) # Matches YYYY
    year=$1
    start_date=$year-01-01
    end_date=$(date -d "$start_date +1 year" '+%F')
    ;;
  *)
    if echo "$1" | grep -q "$month_list"; then
      month_name=$(echo "$1" | awk -F ',' '{print $1}')
      year=$(echo "$1" | awk -F ',' '{print $2}')
      month_number=$(date -d "$month_name 1" '+%m')

      start_date="$year-$month_number-01"
      end_date=$(date -d "$start_date +1 month" '+%F')
    fi

    if [[ $1 = "" ]]; then # Today
      start_date=$(date '+%F')
      end_date=$(date -d "$start_date +1 day" '+%F')
    elif [ "$tmux" = true ]; then # YYYY-MM-DD
      raw_date=$(basename -- "$1")
    else # YYYY-MM-DD
      raw_date="$1"
      polish_date=$(echo "$raw_date" | sed 's/\.md//; s/th//')
      start_date=$(date -d "$polish_date" '+%Y-%m-%d')
      end_date=$(date -d "$start_date +1 day" '+%F')
    fi
    ;;
  esac

  task "end.after:$start_date" and "end.before:$end_date" completed
  [[ "$tmux" = true ]] && sleep 5
}

if [[ "$2" == "tmux" ]]; then
  tmux=true
fi

tskd "$@"
