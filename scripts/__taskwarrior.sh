#!/usr/bin/env bash

TASK_DIR=$HOME/.task/
TASK_GIT_DIR=$HOME/.task-git/

function help() {
  cat <<EOF
Usage: tt [command] [args]
Options:
-i <id>          - Define an ID
Commands
a [args]         - Add
d [args]         - Due today
e -i <id>        - Edit task
git              - Commit changes
k                - Five most urgent tasks
m -i <id> [args] - Modify task
purge            - Purge all deleted tasks
q [args]         - +Quick tasks
t                - Taskwarrior TUI
v                - VIT
EOF
}

function get_id() {
  task status:pending export | jq -r '.[] | "\(.id) | \(.description)"' | fzf | awk -F " " '{print $1}'
}

function commands() {
  case "$command" in
  a)
    task add "$args"
    ;;
  d)
    task list due:today "$args"
    ;;
  e)
    if [ -z "$id" ]; then
      id=$(get_id)
    fi
    task "$id" edit
    ;;
  q)
    task add +quick "$args"
    ;;
  m)
    if [ -z "$args" ]; then
      echo "No arguments used!"
      echo "Use: tt m <args>"
      exit 1
    fi
    if [ -z "$id" ]; then
      id=$(get_id)
    fi
    task "$id" modify "$args"
    ;;
  t)
    taskwarrior-tui
    ;;
  v)
    vit
    ;;
  help)
    help
    exit 0
    ;;
  k)
    task limit:5 "$args"
    ;;
  purge)
    task +DELETED purge
    ;;
  git)
    git -C "$TASK_GIT_DIR" add -A
    git -C "$TASK_GIT_DIR" commit -a -m "$(date +%F)"
    ;;
  *)
    if [[ $(uname -a) =~ "Android" ]]; then
      task termux "$command" "$args"
    else
      task list "$command" "$args"
    fi
    ;;
  esac
}

while getopts ":i:" opt; do
  case "$opt" in
  i)
    id=$OPTARG
    ;;
  ?)
    echo "Error: Invalid option '-$OPTARG'" >&2
    exit 1
    ;;
  esac
done

shift $((OPTIND - 1))

function main() {
  command=$1
  shift
  args="$@"
  commands
}

main "$@"
