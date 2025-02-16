#!/bin/env bash

_rofi() {
  rofi -dmenu -i -no-levenshtein-sort -width 1000 "$@"
}

passdir=${PASSWORD_STORE_DIR:-$HOME/.password-store}

switch_mode="Ctrl+s"
addpass="Ctrl-1"
delete="Ctrl-2"
edit="Ctrl-3"

help_color="#7c5cff"
div_color="#334433"
label="#f067fc"

function otperror() {
  notify-send -u normal "Pass: OTP" "Selected pass entry doesn't contains an OTP." --expire-time=3000
  exit 1
}

function deleteMenu() {
  delask=$(echo -e "1. Yes\n2. No" | _rofi -p '> ' -mesg "<span color='${label}'>Really delete</span> <span color='${help_color}'>$menu?</span>")
  if [[ $val -eq 1 ]]; then
    notify-send -u low "Pass: Delete" "Cancelled!"
    mode=pass main
  fi
  if [[ "$delask" == "1. Yes" ]]; then
    pass rm -f "$menu" && notify-send -u normal "Pass: Delete" "Deleted $menu"
  fi
  mode=pass main
}

function addMenu() {
  addmenu=$(echo | _rofi -p '> ' -mesg "<span color='${label}'>Usage: </span>Insert directory/passname")
  val=$?
  if [[ $val -eq 1 ]]; then
    notify-send -u low "Pass: Add" "Cancelled!"
    mode=pass main
  elif [[ $val -eq 0 ]]; then
    pass generate $addmenu 72
    if [[ $val -eq 1 ]]; then
      notify-send -u normal "Pass: Add" "An error occurred!"
      mode=pass main
    else
      notify-send -u normal "Pass: Add" "Added $addmenu"
    fi
  fi
  mode=pass main
}

function editMenu() {
  term=${TERMCMD:-kitty}
  if [ -z "$EDITOR" ]; then
    export EDITOR=nvim
  fi
  $term -- sh -c "pass edit \"$menu\""
}

main() {
  HELP="<span color='${label}'>Modes: </span><span color='${help_color}'>${switch_mode}</span>: toggle (pass/otp)
<span color='${label}'>Actions: </span><span color='${help_color}'>${addpass}</span>: Add <span color='${div_color}'>|</span> <span color='${help_color}'>${delete}</span>: Delete <span color='${div_color}'>|</span> <span color='${help_color}'>${edit}</span>: Edit"

  pass=$(find "$passdir" -type f -name '*.gpg' -printf '%P\n' | awk -F. '{print $1}')
  menu=$(echo "${pass}" | _rofi -p "$mode" -mesg "${HELP}" -kb-custom-1 "${addpass}" -kb-custom-2 "${switch_mode}" -kb-custom-3 "${delete}" -kb-custom-4 "${edit}")

  val=$?
  case "$val" in
  1) exit ;;
  12) deleteMenu ;;
  11) # Modes
    case "$mode" in
    otp) mode=pass ;;
    pass) mode=otp ;;
    esac
    main
    ;;
  10) addMenu ;;
  13) editMenu ;;
  0)
    case "$mode" in
    pass)
      pass -c "$menu" &&
        notify-send -u critical "Pass: Password" "Copied to clipboard. Clearing in 5 seconds" --expire-time=4500 --wait
      sh ~/scripts/__clearboard.sh
      ;;
    otp)
      pass otp -c "$menu" || error
      notify-send -u critical "Pass: OTP" "Copied to clipboard. Clearing in 5 seconds" --expire-time=4500 --wait
      ;;
    esac
    sh ~/scripts/__clearboard.sh
    ;;
  esac
}

mode=pass main
