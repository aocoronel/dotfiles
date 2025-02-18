#!/bin/env bash

TMP_FILE="/tmp/taskwarrior_notified"
touch "$TMP_FILE"

while true; do
  task status:pending +READY due:today sort:due export | jq -c '.[]' | while read -r TASK; do
    ID=$(echo "$TASK" | jq -r '.id')
    DESC=$(echo "$TASK" | jq -r '.description')
    DUE_TIME=$(echo "$TASK" | jq -r '.due')

    if [ -z "$DUE_TIME" ] || [ "$DUE_TIME" = "null" ]; then
      continue
    fi

    FORMATTED_TIME=$(echo "$DUE_TIME" | sed -E 's/(.{4})(.{2})(.{2})T(.{2})(.{2})(.{2})Z/\4:\5/')
    DUE_TIME_EPOCH=$(echo "$DUE_TIME" | sed -E 's/(.{4})(.{2})(.{2})T(.{2})(.{2})(.{2})Z/\1-\2-\3 \4:\5:\6/' | xargs -I{} date -u -d "{}" +%s)
    # DUE_TIME_EPOCH=$(date -u -d "$(echo "$DUE_TIME" | sed -E 's/(.{4})(.{2})(.{2})T(.{2})(.{2})(.{2})Z/\1-\2-\3 \4:\5:\6/')" +%s 2>/dev/null)

    CURRENT_TIME=$(date +%s)
    SLEEP_TIME=$((DUE_TIME_EPOCH - CURRENT_TIME))

    if [ "$SLEEP_TIME" -gt 0 ]; then
      sleep "$SLEEP_TIME"
    fi

    if grep -q "$ID" "$TMP_FILE"; then
      LAST_NOTIFIED=$(grep "$ID" "$TMP_FILE" | cut -d' ' -f2)
      ELAPSED_TIME=$((CURRENT_TIME - LAST_NOTIFIED))
      if [ "$ELAPSED_TIME" -lt 1800 ]; then
        continue
      fi
    fi

    sed -i "/^$ID /d" "$TMP_FILE"
    echo "$ID $CURRENT_TIME" >>"$TMP_FILE"

    notify-send -a "taskwarrior" "Task Due!" "$DESC at $FORMATTED_TIME"
  done

  sleep 60
done
