#!/usr/bin/env bash

TASK_DIR=$HOME/.task/

function main() {
  local id args
  id=$1
  shift
  args=$@
}

function task_add() {
  task add "$args"
}

function task_modify() {
  task "$id" modify "$args"
}

function task_quick() {
  task add +quick "$args"
}

case "$1" in
a)
  main "$@"
  task_add
  ;;
q)
  main "$@"
  task_quick
  ;;
m)
  main "$@"
  task_modify
  ;;
n)
  task tiny
  ;;
t)
  taskwarrior-tui
  ;;
k)
  task limit:3
  ;;
clean)
  task +DELETED purge
  ;;
git)
  git -C "$TASK_DIR" add -A
  git -C "$TASK_DIR" commit -a -m "Auto Commit"
  ;;
*)
  task list
  ;;
esac
