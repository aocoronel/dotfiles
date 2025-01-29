#!/bin/env bash

function error() {
  notify-send -u normal "Selected pass entry doesn't contains an OTP." --expire-time=3000; exit 1
}

function passmenu-otp() {
  passdir=${PASSWORD_STORE_DIR:-$HOME/.password-store}
  pass=$(find "$passdir" -type f -name '*.gpg' -printf '%P\n' | awk -F. '{print $1}')
  password=$(echo "$pass" | rofi -dmenu "$@")
  pass otp -c "$password" || error
  notify-send -u critical "OTP copied to clipboard. Clearing in 5 seconds" --expire-time=4500 --wait
  sh ~/scripts/__clearboard.sh
}

passmenu-otp
