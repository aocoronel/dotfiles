#!/bin/env bash

TIMER_STATE_FILE="/tmp/pomodoro_timer_state"
OUTPUT_FILE="/tmp/pomodoro_output"
TIMER_SAVED="/tmp/pomodoro_timer_saved"
SESSION_FILE="/tmp/pomodoro_session_count"

tmux_refresh() {
	tmux source-file ~/.tmux.conf
}

is_number() {
	local value=$1
	[[ $value =~ ^-?[0-9]+([.][0-9]+)?$ ]]
}

pomodoro() {
	local seconds=$1
	local symbol=$2
	while [ $seconds -gt 0 ]; do
		local minutes=$((seconds / 60))
		local remaining_seconds=$((seconds % 60))
		echo "{\"text\":\"$symbol $minutes:$remaining_seconds\", \"class\":\"pomodoro\"}" >"$OUTPUT_FILE"
		echo "$seconds" >"$TIMER_SAVED"
		tmux set -g status-right "$symbol $minutes:$remaining_seconds"
		sleep 1
		((seconds--))

		if [ ! -f "$TIMER_STATE_FILE" ]; then
			tmux_refresh
			exit 0
		fi
	done
	rm -f "$TIMER_SAVED"
}

core() {
	local time=1500       # Default focus time (25 min)
	local break=300       # Default short break (5 min)
	local long_break=1200 # Long break (20 min)

	if [ -f "$TIMER_SAVED" ]; then
		local paused_time=$(cat "$TIMER_SAVED")
	fi

	if [ -f "$TIMER_STATE_FILE" ]; then
		rm -f "$TIMER_STATE_FILE"
		tmux_refresh
		notify-send "Pomodoro: Stop" "Timer stopped."
		exit 0
	else
		touch "$TIMER_STATE_FILE"
	fi

	local current_session=1
	if [ -f "$SESSION_FILE" ]; then
		current_session=$(cat "$SESSION_FILE")
	else
		current_session=1
	fi

	if is_number "$paused_time"; then
		notify-send "Pomodoro: Resume" "Remaining Time: $paused_time. Session: $current_session"
		time=$paused_time
	else
		rm -f "$TIMER_SAVED"
	fi

	for session in $(seq "$current_session" 4); do
		if [ ! -f "$TIMER_SAVED" ]; then
			notify-send "Pomodoro: Start" "Focus time! (25 minutes)"
		fi
		pomodoro "$time" 🍅
		echo "$session" >"$SESSION_FILE"

		if [ "$session" -eq 4 ]; then
			notify-send "Pomodoro: Break" "Long Break time! (20 minutes)"
			pomodoro "$long_break" 🕤
		else
			notify-send "Pomodoro: Break" "Break time! (5 minutes)"
			pomodoro "$break" 🕤
		fi
	done

	rm -f "$TIMER_STATE_FILE" "$SESSION_FILE"
	tmux_refresh
	zenity --question --text="Do you want to repeat the cycle?" && core
}

core
notify-send -u normal "Pomodoro: Completed!"
