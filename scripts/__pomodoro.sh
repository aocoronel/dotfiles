#!/bin/env bash

TIMER_STATE_FILE="/tmp/pomodoro_timer_state"

function pomodoro() {
  local seconds=$1
  local symbol=$2
  while [ $seconds -gt 0 ]; do
    local minutes=$((seconds / 60))
    local remaining_seconds=$((seconds % 60))
    printf $minutes:$remaining_seconds
    tmux set -g status-right "$symbol $minutes:$remaining_seconds"
    sleep 1
    ((seconds--))

  if [ ! -f "$TIMER_STATE_FILE" ]; then
    tmux source-file ~/.tmux.conf
    exit 0
  fi
  done
}

function core() {
  if [ -f "$TIMER_STATE_FILE" ]; then
    rm "$TIMER_STATE_FILE"
    tmux source-file ~/.tmux.conf
    notify-send "Pomodoro timer stopped."
    exit 0
  else
    touch "$TIMER_STATE_FILE"
  fi
  for session in {1..4}; do
    notify-send "Focus time! (25 minutes)"
    pomodoro 1500 🍅
    notify-send "Break time! (5 minutes)"
    pomodoro 300 🕤

    if [ $session -lt 4 ]; then
      notify-send "Long Break time! (20 minutes)!"
      pomodoro 1200
    fi
  done
  rm "$TIMER_STATE_FILE"
  tmux source-file ~/.tmux.conf
  zenity --question --text="Do you want to repeat? (y/n)" && core
}

core
notify-send -u normal "Pomodoro Completed!"
