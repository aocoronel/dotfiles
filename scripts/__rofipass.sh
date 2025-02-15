#!/bin/env bash

_rofi() {
  rofi -dmenu -i -no-levenshtein-sort -width 1000 "$@"
}

passdir=${PASSWORD_STORE_DIR:-$HOME/.password-store}
pass=$(find "$passdir" -type f -name '*.gpg' -printf '%P\n' | awk -F. '{print $1}')

switch_mode="Ctrl+s"

help_color="#7c5cff"
label="#f067fc"

function error() {
  notify-send -u normal "Selected pass entry doesn't contains an OTP." --expire-time=3000
  exit 1
}

main() {
  HELP="<span color='${label}'>Binds: </span><span color='${help_color}'>${switch_mode}</span>: Toggle (pass/otp)"
  menu=$(echo "${pass}" | _rofi -p "$mode" -mesg "${HELP}" -kb-custom-2 "${switch_mode}")

  val=$?
  case "$val" in
  1) exit ;;
  11)
    case "$mode" in
    otp) mode=pass ;;
    pass) mode=otp ;;
    esac
    main
    ;;
  0)
    case "$mode" in
    pass)
      pass -c "$menu" &&
        notify-send -u critical "Password copied to clipboard. Clearing in 5 seconds" --expire-time=4500 --wait
      sh ~/scripts/__clearboard.sh
      ;;
    otp)
      pass otp -c "$menu" || error
      notify-send -u critical "OTP copied to clipboard. Clearing in 5 seconds" --expire-time=4500 --wait
      ;;
    esac
    sh ~/scripts/__clearboard.sh
    ;;
  esac
}

mode=pass main
