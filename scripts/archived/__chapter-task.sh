#!/usr/bin/env bash

function help() {
  cat <<EOF
Book Reading Task Manager
Usage: $0 [option]
Available options:
add                             - Adds a new book
del                             - Delete a book
next                            - Creates new chapter
help                            - Displays this message and exits
EOF
}

function update() {
  if [ "$task_name" = "" ]; then
    exit 1
  elif [ "$task_chapter" = "" ]; then
    exit 1
  fi
  task project:"$task_name" description:"read: ch $task_chapter" done
  task_chapter=$(expr $task_chapter + 1)
  task add project:"$task_name" Read Chapter "$task_chapter" +book
}

function grab_task() {
  task_name=$(task book | grep "Read" | awk '{print $1}' | fzf --prompt "Choose a book: ")
  task_chapter=$(task book project:$task_name | grep "$task_name" | awk '{print $4}')
  update
}

function add() {
  read -p "Name your book: " book_name
  book_name=$(echo "$book_name" | tr '[:upper:]' '[:lower:]' | tr '.' '-' | tr ':' '-' | tr ' ' '-')
  task add project:"$book_name" Read Chapter 1 +book
}

function delete() {
  grab_task
  if [ "$task_name" = "" ]; then
    exit 1
  elif [ "$task_chapter" = "" ]; then
    exit 1
  fi
  task project:"$task_name" description:"read: ch $task_chapter" delete
}

case "$1" in
"next")
  grab_task
  ;;
"add")
  add
  ;;
"del")
  delete
  ;;
"")
  help
  ;;
esac
