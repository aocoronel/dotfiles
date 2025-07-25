#!/usr/bin/env bash

CHAT_DIR="$HOME/.chat/"
EDITOR="${EDITOR:-nvim}"

if [ ! -d "$HOME/.x-cmd.root" ]; then
  echo "X-CMD is not installed!"
  echo "Check installation guide: https://get.x-cmd.com)"
  exit
fi

check_command() {
  for cmd in "$@"; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "Error: $cmd could not be found. Please install it." >&2
      exit 1
    fi
  done
}

check_command fzf nvim

function create_chat_dir() {
  mkdir -p "$CHAT_DIR"
}

function notify_me() {
  notify-send -u normal "Gemini: Request" "Your request finished!"
}

# shellcheck disable=SC2120
# shellcheck disable=SC2016
function choose_file() {
  HEADER="A-a: Select All / A-s: Deselect All / C-/: Preview / A-d: Delete / C-r: Ripgrep (Multi-select) / C-l: List"
  PROMPT="Choose a file to read: "
  DELETE_BIND="Alt-d:execute(echo -n 'Delete {+} [y/N]? ' && read -r yn && [[ \$yn =~ ^[Yy]$ ]] && rm {+})+reload(ls)"
  LS_RELOAD="change-preview(bat --color=always {})+reload(ls)"
  RG_RELOAD="reload(rg --column --color=always --smart-case {q} || :)+change-preview(bat --color=always --highlight-line {2} {1} || bat --style=full --color=always {1})+change-preview-window(~4,+{2}+4/3,<80(up))"
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
          nvim {1} +{2}     # No selection. Open the current line in Vim.
          else
            nvim +cw -q {+f}  # Build quickfix list for the selected items.
          fi'

  cd "$CHAT_DIR" || return
  RESULT=$(
    fzf --disabled --ansi --multi --tmux 88% \
      --bind "$DELETE_BIND" \
      --bind 'alt-a:select-all,alt-s:deselect-all,ctrl-/:toggle-preview' \
      --bind "ctrl-l:$LS_RELOAD" \
      --bind "ctrl-r:$RG_RELOAD" \
      --bind "enter:execute:$OPENER" \
      --bind "start:enable-search+${LS_RELOAD}" \
      --delimiter : \
      --header "$HEADER" \
      --preview 'bat --color=always {}' \
      --preview-window up:65% \
      --prompt "$PROMPT" \
      --query "$*"
  )

  if [ -n "$RESULT" ]; then
    "$EDITOR" "$RESULT"
  else
    echo "Exitting..."
  fi
}
# shellcheck enable=all

function help() {
  cat <<EOF
Usage: $0 [type] [question]
Available types:
code                - Sets ID to code
dir                 - Select cached chat data to read or edit
*                   - Sets ID to personal
EOF
}

function main() {
  local uuid
  if [ -z "$2" ]; then
    help
    exit
  fi
  local id="$1"
  shift
  local question="$*"
  uuid=$(date +%Y%M%d%H%M%S)
  local filename="$CHAT_DIR/$id-$uuid.md"

  x gemini chat request "$mode ${question}" >"$filename"
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
# IDs
"code")
  shift
  mode="You are an AI assistant that helps user write code. Heres is my question:"
  main "code" "$@"
  ;;
*)
  shift
  mode="You are an AI assistant that helps user think. Heres is my question:"
  main "personal" "$@"
  ;;
esac
