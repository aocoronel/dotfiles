#!/usr/bin/env bash

# "Quickly clone all Git repos, or fetch all"

DEV_DIR=${DEV:-$HOME/dev}
REPOX_FILE="$HOME/.repox"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function usage() {
  cat <<EOF
Repox: Clone/Fetch all Git repos
Usage: __repox.sh [option] <command> [sub-dir]
Available options:
-v                   - Enable verbose
-r                   - Use Repox File
Available commands:
help                 - Display this message and exits
Examples:
__repox.sh github # $DEV_DIR/github/
__repox.sh codeberg # $DEV_DIR/codeberg/
EOF
}

function bar() {
  ((current_line++))
  percentage=$((current_line * 100 / total_lines))
  progress_bar="["
  for ((i = 0; i < percentage; i += 5)); do
    progress_bar+="#"
  done
  for ((i = percentage; i < 100; i += 5)); do
    progress_bar+=" "
  done
  progress_bar+="]"
  printf "\r${BLUE}Progress: ${GREEN}%s ${BLUE}%d%% - %s${NC}" "$progress_bar" "$percentage" "$message"
  echo
}

function get_repos() {
  gh repo list | grep "$(whoami)" | awk -F " " '{print $1}' >$TMP_DIR
}

function fetch() {
  current_line=0
  total_lines=$(wc -l <"$TMP_DIR")
  while IFS= read -r repo; do
    repo_name="$(basename "$repo")"
    if [ ! -d "$DEV_DIR/$sub_dir/$repo_name" ]; then
      if ! gh repo clone "$repo" "$DEV_DIR/$sub_dir/$repo_name"; then
        echo "An error occured at $repo"
      fi
      if [ -n "$VERBOSE" ]; then
        message="Cloned $repo"
      fi
    else
      if ! git -C "$DEV_DIR/$sub_dir/$repo_name" fetch; then
        echo "An error occured at $repo"
      fi
      if [ -n "$VERBOSE" ]; then
        message="Fetched $repo"
      fi
    fi
    bar
  done <"$TMP_DIR"
}

function main() {
  if [ -z "$sub_dir" ]; then
    echo "Missing sub directory!"
    echo "Usage: __repox.sh github"
    exit 1
  fi
  if [ -n "$REPOX" ]; then
    TMP_DIR="$REPOX_FILE" # URL to all Git repos
  else
    TMP_DIR="/tmp/repox"
    get_repos # Use gh to get all Github repos
  fi
  fetch
}

while getopts ":hvr" opt; do
  case "$opt" in
  h)
    help
    exit 0
    ;;
  v)
    VERBOSE=true
    ;;
  r)
    REPOX=true
    ;;
  ?)
    echo "Error: Invalid option '-$OPTARG'" >&2
    exit 1
    ;;
  esac
done

shift $((OPTIND - 1))

case "$1" in
help)
  usage
  exit 0
  ;;
*)
  sub_dir=$1
  main
  ;;
esac
