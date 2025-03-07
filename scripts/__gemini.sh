#!/usr/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__gemini.sh

CHAT_DIR="$HOME/.chat/"
EDITOR="${EDITOR:-nvim}"

if [ ! -d "$HOME/.x-cmd.root" ]; then
  echo "X-CMD is not installed!"
  echo "Check installation guide: https://get.x-cmd.com)"
  exit
elif ! [ -x "$(command -v fzf)" ]; then
  echo "fzf is not installed!"
  echo "Please install it"
  exit
elif ! [ -x "$(command -v nvim)" ]; then
  echo "nvim is not installed!"
  echo "Please install it"
  exit
fi

function create_chat_dir() {
  mkdir -p "$CHAT_DIR"
}

function notify_me() {
  notify-send -u normal "Gemini: Request" "Your request finished!"
}

function rfv() (
  cd "$CHAT_DIR" || exit
  sh ~/scripts/__fuzzy-grep.sh "$args"
)

function choose_file() {
  local HEADER="A-d: Delete"
  local PROMPT="Choose a file to read: "
  local DELETE_BIND="Alt-d:execute(echo -n 'Delete {+} [y/N]? ' && read -r yn && [[ \$yn =~ ^[Yy]$ ]] && rm {+})+reload(find \"$CHAT_DIR\" -type f)"

  RESULT=$(
    find "$CHAT_DIR" -type f | fzf --tmux 88% \
      --bind "$DELETE_BIND" \
      --header "$HEADER" \
      --prompt "$PROMPT" \
      --preview-window right:60% \
      --preview 'bat {}'
  )

  if [ -n "$RESULT" ]; then
    "$EDITOR" "$RESULT"
  else
    echo "Exitting..."
  fi
}

function help() {
  cat <<EOF
Usage: $0 [type] [question]
Available types:
code                - Sets ID to code
dir                 - Select cached chat data to read or edit
*                   - Sets ID to personal
EOF
}

function generate_chat() {
  if [ -z "$2" ]; then
    help
    exit
  fi
  local id="$1"
  shift
  local question="$*"
  local uuid=$(uuidgen)
  local filename="$CHAT_DIR/$id-$uuid.md"

  x gemini chat request "${question}" >"$filename"
  status=$?

  if [ $status -ne 0 ]; then
    echo "Error: x gemini chat command failed."
    rm -f "$filename"
    exit 1
  else
    notify_me
    "$EDITOR" "$filename"
  fi
}

if [ ! -d "$CHAT_DIR" ]; then
  create_chat_dir
fi

if [ -z "$1" ]; then
  help
  exit
fi

case "$1" in
# Specials
"dir") choose_file ;;
"rg")
  args="$*"
  rfv
  ;;
# IDs
"code") generate_chat "code" "$@" ;;
*) generate_chat "personal" "$@" ;;
esac
