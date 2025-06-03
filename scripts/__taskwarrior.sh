#!/usr/bin/env bash

TASK_DIR=$HOME/.task/
TASK_GIT_DIR=$HOME/.task-git/

function commands() {
  case "$command" in
  a)
    task add "$args"
    ;;
  d)
    task list due:today "$args"
    ;;
  q)
    task add +quick "$args"
    ;;
  m)
    task "$id" modify "$args"
    ;;
  t)
    taskwarrior-tui
    ;;
  k)
    task limit:3 "$args"
    ;;
  clean)
    task +DELETED purge
    ;;
  git)
    git -C "$TASK_GIT_DIR" add -A
    git -C "$TASK_GIT_DIR" commit -a -m "$(date +%F)"
    ;;
  *)
    if [[ $(uname -a) =~ "Android" ]]; then
      task termux "$args"
    else
      task list "$args"
    fi
    ;;
  esac
}

function main() {
  command=$1
  shift
  id=$1
  shift
  args=$@
  commands
}

main "$@"
