#!/usr/bin/env bash

modefile=$HOME/.cache/waybar-task

ORG_DIR="$HOME/org"
# taskmode="org"
taskmode="taskwarrior"

case "$1" in
"all") echo "all" >"$modefile" ;;
"today") echo "today" >"$modefile" ;;
esac

if [ "$taskmode" == "taskwarrior" ]; then
  if [ -f "$modefile" ]; then
    if [ "$(cat "$modefile")" = "all" ]; then
      tasks=$(task status:pending count)
    elif [ "$(cat "$modefile")" = "today" ]; then
      tasks=$(task status:pending due.before:tomorrow count)
    fi
  else
    tasks=$(task status:pending count)
  fi
elif [ "$taskmode" == "org" ]; then
  if [ ! -d "$ORG_DIR" ]; then
    exit 1
  fi
  if [ -f "$modefile" ]; then
    if [ "$(cat "$modefile")" = "all" ]; then
      tasks=$(rg --max-depth 2 -o "^\*+\s+TODO" "$ORG_DIR" --no-filename | wc -l)
    elif [ "$(cat "$modefile")" = "today" ]; then
      TODAY=$(date +"%Y-%m-%d")
      tasks=$(rg --max-depth 2 -o "SCHEDULED: <$TODAY" "$ORG_DIR" --no-filename | wc -l)
    fi
  else
    tasks=$(rg --max-depth 2 -o "^\*+\s+TODO" "$ORG_DIR" --no-filename | wc -l)
  fi
fi

tooltip="Current Mode: $(cat "$modefile")"
tooltip+="\nLMB: Show all remaining tasks"
tooltip+="\nRMB: Show today remaining tasks"

if [ -z "$tasks" ]; then
  echo "{\"text\": \" No tasks\", \"tooltip\": \"$tooltip\"}"
else
  echo "{\"text\":\" $tasks tasks\", \"tooltip\": \"$tooltip\"}"
fi
