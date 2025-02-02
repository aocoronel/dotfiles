#!/bin/env bash

TIMER_STATE_FILE="/tmp/pomodoro_timer_state"
OUTPUT_FILE="/tmp/pomodoro_output"
TIMER_SAVED="/tmp/pomodoro_timer_saved"
SESSION_FILE="/tmp/pomodoro_session_count"

function help() {
	cat <<EOF
Pomodoro Control
Usage: $0 [option]
Available options:
reset                           - Clears all temp files
timer                           - Resets the timer
session                         - Resets the session
toggle                          - Toggle the pomodoro
rofi                            - Interactive using Rofi
help                            - Displays this message and exits
EOF
}

function reset() {
	rm $TIMER_STATE_FILE
	rm $TIMER_SAVED
	rm $SESSION_FILE
	rm $OUTPUT_FILE
}

function timer() {
	rm $TIMER_SAVED
}

function session() {
	rm $SESSION_FILE
}

function toggle() {
	if [ -f "$TIMER_STATE_FILE" ]; then
		rm $TIMER_STATE_FILE
	else
		sh "$HOME/scripts/__pomodoro.sh"
	fi
	rm $OUTPUT_FILE
}

function rofi_control() {
	choice=$(echo -e "toggle\ntimer\nsession\nreset" | rofi -dmenu)
	if [ "$choice" = "reset" ]; then
		reset
	elif [ "$choice" = "session" ]; then
		session
	elif [ "$choice" = "timer" ]; then
		timer
	elif [ "$choice" = "toggle" ]; then
		toggle
	else
		return
	fi
}

case "$1" in
"reset")
	reset
	;;
"timer")
	timer
	;;
"session")
	session
	;;
"toggle")
	toggle
	;;
"rofi")
	rofi_control
	;;
"*")
	help
	;;
esac
