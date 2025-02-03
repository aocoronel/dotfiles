#!/bin/env bash

clipmethod=$(echo "$XDG_SESSION_TYPE")

function clearboard() {
	if [ "$clipmethod" = "x11" ]; then
		dunstctl close-all
		echo "" | xclip -sel clip
	elif [ "$clipmethod" = "wayland" ]; then
		cliphist wipe
		dunstctl close-all
		echo "" | wl-copy
	fi
}

clearboard
