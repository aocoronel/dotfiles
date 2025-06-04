#!/usr/bin/env bash

function help() {
  cat <<EOF
Usage: tt [command] [args]
Options:
-i <id>          - Define an ID
Commands
a [args]         - Add
d [args]         - Due today
e -i <id>        - Edit task
k                - Five most urgent tasks
m -i <id> [args] - Modify task
purge            - Purge all deleted tasks
q [args]         - +Quick tasks
t                - Taskwarrior TUI
v                - VIT
EOF
}

function repeat() {
  task $@
}

function get_id() {
  task status:pending export | jq -r '.[] | "\(.id) | \(.description)"' | fzf | awk -F " " '{print $1}'
}

function _task() {
  local args=$@
  if [[ $(uname -a) =~ "Android" ]]; then
    task termux "$args"
  else
    task "$args"
  fi
}

function commands() {
  case "$command" in
  a)
    task add "$args"
    ;;
  d)
    _task due:today "$args"
    ;;
  e)
    if [ -z "$id" ]; then
      id=$(get_id)
    fi
    task "$id" edit
    ;;
  r) # repeat
    echo "Repeating: task $args"
    echo "Enter task arguments (blank to quit):"
    while true; do
      read repeat_args
      if [[ "$repeat_args" == "" ]] ; then
        break
      fi
      repeat $args $repeat_args
    done
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
    _task limit:5 "$args"
    ;;
  purge)
    task +DELETED purge
    ;;
  *)
    _task "$command" "$args"
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
