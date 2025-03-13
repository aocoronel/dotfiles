#!/usr/bin/env bash

# https://github.com/user/dotfiles/blob/main/scripts/__rofitmux.sh

if ! command -v rofi &>/dev/null; then
  echo "rofi could not be found. Please install it."
  exit 1
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/lib/get_env.sh"
source "$SCRIPT_DIR/lib/tmux_functions.sh"

get_term # Get TERMCMD env

if [ -z "$TERMCMD" ]; then
  echo "Error: TERMCMD env at .localenv not found"
  exit 1
fi

_rofi() {
  rofi -dmenu -i -no-levenshtein-sort -width 1000 -p "$mode" -mesg "${HELP}" -kb-custom-1 "${delete}" -kb-custom-2 "${switch_mode}" "$@"
}

switch_mode="Ctrl+s"
delete="Ctrl-1"

help_color="#7c5cff"
div_color="#334433"
label="#f067fc"

main() {
  HELP="<span color='${label}'>Modes: </span><span color='${help_color}'>${switch_mode}</span>: toggle (tmux/tmuxp)
<span color='${label}'>Actions: </span><span color='${help_color}'>${delete}</span>: Close session"

  case "$mode" in
  tmuxp)
    session=$(find "$HOME/.config/tmuxp/" -type f -name '*.yaml' -printf '%P\n' | awk -F. '{print $1}')
    ;;
  tmux)
    session=$(tmux ls | awk -F ":" '{print $1}')
    ;;
  *)
    notify-send -u normal "Tmux: Error" "Incorrect mode selected"
    exit 1
    ;;
  esac

  menu=$(echo "${session}" | _rofi)

  val=$?
  case "$val" in
  1) exit ;;
  11) # Modes
    case "$mode" in
    tmux) mode=tmuxp ;;
    tmuxp) mode=tmux ;;
    esac
    main
    ;;
  10)
    close_tmux "$menu"
    main
    ;;
  0)
    case "$mode" in
    tmux)
      open_tmux_term "$menu"
      ;;
    tmuxp)
      open_tmuxp_term "$menu"
      ;;
    esac
    ;;
  esac
}

mode=tmux main
