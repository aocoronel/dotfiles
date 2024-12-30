#!/bin/env bash

CONFIG="$HOME/.tmuxprofile"
if [[ ! -f "$CONFIG" ]]; then
  echo "No configuration file set!"
  touch "$CONFIG"
  echo "Created a config file in $CONFIG"
  echo "Please add desired directories in the configuration file"
  echo "Example: ~/dev/ ~/Downloads/ /mnt/"
  echo "Environment variables are allowed"
  exit
fi

DIRECTORIES=($(cat ~/.tmuxprofile))
TMUXP_CONFIG="$HOME/.config/tmuxp/"

HEADER=" Ctrl-s: Sessions / Ctrl-d: Directory / Ctrl-f: Tmuxp / Ctrl-t: Kill session"

SESSION_BIND="Ctrl-s:change-prompt(Sessions> )+reload(tmux ls -F '#S')"
DIR_BIND="Ctrl-d:change-prompt(Directory> )+reload(find "${DIRECTORIES[@]}" -mindepth 1 -maxdepth 1 -type d)"
TMUXP_BIND="Ctrl-f:change-prompt(Tmuxp> )+reload(find "$TMUXP_CONFIG" -type f -name '*.yaml')"
KILL_SESSION_BIND="Ctrl-t:execute(tmux kill-session -t {+})+reload(tmux ls -F '#S')"

RESULT=$(
  (tmux ls -F '#S') | fzf --tmux 85% \
    --bind "$DIR_BIND" \
    --bind "$TMUXP_BIND" \
    --bind "$SESSION_BIND" \
    --bind "$KILL_SESSION_BIND" \
    --header "$HEADER" \
    --prompt "$PROMPT" \
    --preview-window up:75% \
    --preview 'if [[ -d {+} ]]; then eza -la {}; elif [[ -f {+} ]]; then bat {1}; else tmux capture-pane -pt {} | tail -n 20; fi'
)

if [ -z "$RESULT" ]; then
	exit 0
fi

if [ -f "$RESULT" ]; then
  RESULT=$(echo  $RESULT | sed 's|.*/||' | awk -F '.' '{print $1}')
  if [[ -n "$RESULT" ]]; then
    if tmux has-session -t "$RESULT" 2>/dev/null; then
      if [ -z "$TMUX" ]; then
        tmux attach-session -t "$RESULT"
        exit 0
      else
        tmux switchc -t "$RESULT"
        exit 0
      fi
    else
      if [ -z "$TMUX" ]; then
        tmuxp load "$RESULT" -d
        tmux attach-session -t "$RESULT"
        exit 0
      else
        tmuxp load "$RESULT" -d
        tmux switchc -t "$RESULT"
        exit 0
      fi
    fi
  fi
fi

if [ -d "$RESULT" ]; then
  find_path=$(find "$DIRECTORIES" -name "$RESULT")
fi

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
