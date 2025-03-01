#!/bin/bash

modefile=$HOME/.cache/waybar-task

case "$1" in
"all") echo "all" >"$modefile" ;;
"today") echo "today" >"$modefile" ;;
esac

if [ -f "$modefile" ]; then
  if [ "$(cat "$modefile")" = "all" ]; then
    tasks=$(task status:pending count)
  elif [ "$(cat "$modefile")" = "today" ]; then
    tasks=$(task status:pending due:today count)
  fi
else
  tasks=$(task status:pending count)
fi

tooltip="Current Mode: $(cat "$modefile")"
tooltip+="\nLMB: Show all remaining tasks"
tooltip+="\nRMB: Show today remaining tasks"

if [ -z "$tasks" ]; then
  echo "{\"text\": \"No tasks\", \"tooltip\": \"$tooltip\"}"
else
  echo "{\"text\":\"$tasks tasks\", \"tooltip\": \"$tooltip\"}"
fi
