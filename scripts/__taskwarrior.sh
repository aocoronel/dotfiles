#!/usr/bin/env bash

function help() {
  cat <<EOF
Usage: tt [command] [args]
Options:
-i <id>          - Define an ID
Commands
c [args]         - Change context
d [args]         - Overdue and due today
e -i <id>        - Edit task
k [args]         - Five most urgent tasks
m -i <id> [args] - Modify task
purge            - Purge all deleted tasks
q [args]         - +Quick tasks
s                - Sync
t                - Open Taskwarrior TUI
v                - Open VIT
EOF
}

function repeat() {
  task "$@"
}

function get_id() {
  task status:pending export | jq -r '.[] | "\(.id) | \(.description)"' | fzf | awk -F " " '{print $1}'
}

function _task() {
  local args=$*
  if [[ $(uname -a) =~ "Android" ]]; then
    task termux "$args"
  else
    task "$args"
  fi
}

function commands() {
  case "$command" in
  d) # overdue/due today
    task status:pending +READY due.before:tomorrow sort:due "$args"
    ;;
  c) # context
    task context "$args"
    ;;
  e) # edit
    if [ -z "$id" ]; then
      id=$(get_id)
    fi
    task "$id" edit
    ;;
  help)
    help
    exit 0
    ;;
  k) # show top 5
    _task limit:5 "$args"
    ;;
  m) # modify
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
  purge)
    task +DELETED purge
    ;;
  q) # +quick
    task add +quick "$args"
    ;;
  r) # repeat
    echo "Repeating: task $args"
    echo "Enter task arguments (blank to quit):"
    while true; do
      read repeat_args
      if [[ "$repeat_args" == "" ]]; then
        break
      fi
      repeat "$args" "$repeat_args"
    done
    ;;
  s) # sync
    task sync
    ;;
  t)
    taskwarrior-tui
    ;;
  v)
    vit
    ;;
  *) # any command
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
