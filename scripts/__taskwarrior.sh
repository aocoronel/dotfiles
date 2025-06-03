#!/usr/bin/env bash

TASK_DIR=$HOME/.task/

# tt m 2 hello world
# Same as: task 2 modify hello world
command=$1
shift
id=$1
shift
args=$@


function task_add() {
  task add "$args"
}

function task_modify() {
  task "$id" modify "$args"
}

function task_quick() {
  task add +quick "$args"
}

case "$command" in
a)
  task_add
  ;;
q)
  task_quick
  ;;
m)
  task_modify
  ;;
n)
  task termux
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
  if [[ $(uname -a) =~ "Android" ]]; then
    task termux
  else
    task list
  fi
  ;;
esac
