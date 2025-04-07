#!/usr/bin/env bash

ORG_DIR=~/org/journal/daily/

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
  start_date=""
  end_date=""

  case "$1" in
  *-W[0-9][0-9]) # Matches YYYY-WXX
    year=$(echo "$1" | awk -F '-W' '{print $1}')
    week=$(echo "$1" | awk -F '-W' '{print $2}')
    printf -v week "%02d" "$week"
    start_date=$(date -d "$year-01-01 +$(((week - 1) * 7)) days -$(date -d "$year" +%u) days +1 day" '+%F')
    end_date=$(date -d "$start_date +6 days" '+%F')
    ;;
  [0-9][0-9][0-9][0-9]) # Matches YYYY
    year=$1
    start_date=$year-01-01
    end_date=$(date -d "$start_date +1 year" '+%F')
    ;;
  *-[0-9][0-9]-[0-9][0-9]) # Matches YYYY-MM-DD
    raw_date="$1"
    polish_date=$(echo "$raw_date" | sed 's/\.md//; s/th//')
    start_date=$(date -d "$polish_date" '+%Y-%m-%d')
    rg -HN "\* DONE " "$ORG_DIR/$start_date.org"
    exit 0
    ;;
  *)
    if echo "$1" | grep -q "$month_list"; then
      month_name=$(echo "$1" | awk -F ',' '{print $1}')
      year=$(echo "$1" | awk -F ',' '{print $2}')
      month_number=$(date -d "$month_name 1" '+%m')

      start_date="$year-$month_number-01"
      end_date=$(date -d "$start_date +1 month" '+%F')
    else
      if [[ $1 = "" ]]; then # Today
        start_date=$(date '+%F')
        end_date=$(date -d "$start_date +1 day" '+%F')
      else # YYYY-MM
        case "$1" in
        *-[0-9][0-9]) # Matches YYYY-MM-DD
          year=$(echo "$1" | awk -F '-' '{print $1}')
          month=$(echo "$1" | awk -F '-' '{print $2}')
          start_date="$year"-"$month"-01
          end_date=$(date -d "$start_date +1 month" '+%F')
          ;;
        *)
          echo "Invalid format"
          exit 1
          ;;
        esac
      fi
    fi
    ;;
  esac
}

function get_done_tasks() {
  declare -i i
  i=1
  if [ -f "$ORG_DIR/$start_date.org" ]; then
    dates="$ORG_DIR/$start_date.org"
  fi
  while true; do
    current_date=$(date -d "$start_date +$i days" +%Y-%m-%d)
    i+=1
    if [ -f "$ORG_DIR/$current_date.org" ]; then
      dates+=("$ORG_DIR/$current_date.org")
    fi
    if [ "$current_date" == "$end_date" ]; then
      break
    fi
  done
}

tskd "$@"
if [ -z "$start_date" ] || [ -z "$end_date" ]; then
  echo "Missing start and end date"
  exit 1
fi

get_done_tasks
if [ -z "$dates" ]; then
  echo "Given date does no have any done tasks!"
  exit 0
fi

rg -HN "\* DONE " "${dates[@]}"
