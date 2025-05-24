#!/usr/bin/env bash

ORG_DIR=$HOME/org/journal/daily/
EMACS_MODE=true

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

  case "$*" in
  *-W[0-9][0-9]) # Matches YYYY-WXX
    year=$(echo "$*" | awk -F '-W' '{print $1}')
    week=$(echo "$*" | awk -F '-W' '{print $2}')
    printf -v week "%02d" "$week"
    start_date=$(date -d "$year-01-01 +$(((week - 1) * 7)) days -$(date -d "$year" +%u) days +1 day" '+%F')
    end_date=$(date -d "$start_date +6 days" '+%F')
    ;;
  [0-9][0-9][0-9][0-9]) # Matches YYYY
    year=$*
    start_date=$year-01-01
    end_date=$(date -d "$start_date +1 year" '+%F')
    ;;
  *-[0-9][0-9]-[0-9][0-9]) # Matches YYYY-MM-DD
    raw_date="$*"
    polish_date=$(echo "$raw_date" | sed 's/\.md//; s/th//')
    start_date=$(date -d "$polish_date" '+%Y-%m-%d')
    [ ! -f "$ORG_DIR/$start_date.org" ] && {
      echo "Given date does no have any done tasks!"
      exit 0
    }
    rg -HN "\* DONE " "$ORG_DIR/$start_date.org"
    exit 0
    ;;
  *)
    if echo "$*" | grep -q "$month_list"; then
      month_name=$(echo "$*" | awk -F ',' '{print $1}')
      year=$(echo "$*" | awk -F ',' '{print $2}')
      month_number=$(date -d "$month_name 1" '+%m')
      start_date="$year-$month_number-01"
      end_date=$(date -d "$start_date +1 month" '+%F')
    else
      if [[ $* = "" ]]; then # Today
        start_date=$(date '+%F')
        end_date=$(date -d "$start_date +1 day" '+%F')
      else # YYYY-MM
        case "$*" in
        *-[0-9][0-9]) # Matches YYYY-MM-DD
          year=$(echo "$*" | awk -F '-' '{print $1}')
          month=$(echo "$*" | awk -F '-' '{print $2}')
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

if [ "$EMACS_MODE" = "true" ]; then
  rg -Hn "\* DONE " "${dates[@]}"
else
  rg -HN "\* DONE " "${dates[@]}"
fi
