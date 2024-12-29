#!/bin/env bash

DIRECTORIES=($OBSIDIAN $DEV)

HEADER=" Ctrl-s: Sessions / Ctrl-d: Directory / Ctrl-t: Kill session"

SESSION_BIND="Ctrl-s:change-prompt(Sessions> )+reload(tmux ls -F '#S')"
DIR_BIND="Ctrl-d:change-prompt(Directory> )+reload(find "${DIRECTORIES[@]}" -mindepth 1 -maxdepth 1 -type d)"
KILL_SESSION_BIND="Ctrl-t:execute(tmux kill-session -t {+})+reload(tmux ls -F '#S')"

RESULT=$(
  (tmux ls -F '#S') | fzf --tmux 85% \
    --bind "$DIR_BIND" \
    --bind "$SESSION_BIND" \
    --bind "$KILL_SESSION_BIND" \
    --header "$HEADER" \
    --prompt "$PROMPT" \
    --preview-window up:75% \
    --preview 'if [[ -d {+} ]]; then eza -la {}; else tmux capture-pane -pt {} | tail -n 20; fi'
)

if [ -z "$RESULT" ]; then
	exit 0
fi

find_path=$(find "$DIRECTORIES" -name "$RESULT")

if [ -n "$find_path" ]; then
  RESULT=$find_path
fi

SESSION_NAME=$(echo "$RESULT" | tr ' ' '_' | tr '.' '_' | tr ':' '_')

if tmux ls -F '#S' | grep -q "^$SESSION_NAME$"; then
	SESSION="$SESSION_NAME"
else
	SESSION=""
fi

if [ -z "$TMUX" ]; then
	if [ -z "$SESSION" ]; then
		tmux new-session -s "$SESSION_NAME" -c "$RESULT"
	else
		tmux attach -t "$SESSION"
	fi
else
	if [ -z "$SESSION" ]; then
		tmux new-session -d -s "$SESSION_NAME" -c "$RESULT"
		tmux switch-client -t "$SESSION_NAME"
	else
		tmux switch-client -t "$SESSION"
	fi
fi
