#!/usr/bin/env bash

OUTPUT_FILE="/tmp/pomodoro_output"

if [ -f "$OUTPUT_FILE" ]; then
  cat "$OUTPUT_FILE"
else
  echo "{\"text\":\"\", \"class\":\"pomodoro\"}"
fi
