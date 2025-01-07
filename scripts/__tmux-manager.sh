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

source "$HOME/.env"

DIRECTORIES=($(cat ~/.tmuxprofile))
TMUXP_CONFIG="$HOME/.config/tmuxp/"

case "$1" in
  "d")
    run="find "${DIRECTORIES[@]}" -mindepth 1 -maxdepth 1 -type d"
    ;;
  "f")
    run="find "$TMUXP_CONFIG" -type f -name '*.yaml'"
    ;;
  "z")
    run="zoxide query -l"
    ;;
  "")
    run="tmux ls -F '#S'"
    ;;
esac

HEADER=" Ctrl-s: Sessions : Ctrl-t: Kill session / Ctrl-d: Directory / Ctrl-f: Tmuxp"

SESSION_BIND="Alt-s:change-prompt(Sessions> )+reload(tmux ls -F '#S')"
DIR_BIND="Alt-d:change-prompt(Directory> )+reload(find "${DIRECTORIES[@]}" -mindepth 1 -maxdepth 1 -type d)"
ZOXIDE_BIND="Alt-z:change-prompt(Zoxide> )+reload(zoxide query -l)"
TMUXP_BIND="Alt-f:change-prompt(Tmuxp> )+reload(find "$TMUXP_CONFIG" -type f -name '*.yaml')"
KILL_SESSION_BIND="Alt-k:execute(tmux kill-session -t {+})+reload(tmux ls -F '#S')"
TOGGLE_PREVIEW="Alt-p:toggle-preview"

RESULT=$(eval $run | fzf --tmux 88% \
    --bind "$DIR_BIND" \
    --bind "$ZOXIDE_BIND" \
    --bind "$TMUXP_BIND" \
    --bind "$SESSION_BIND" \
    --bind "$KILL_SESSION_BIND" \
    --bind "$TOGGLE_PREVIEW" \
    --header "$HEADER" \
    --prompt "$PROMPT" \
    --preview-window up:67% \
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
