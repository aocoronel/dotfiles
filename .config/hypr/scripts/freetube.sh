#!/bin/env bash

# "Setup Invidious, than run FreeTube"

invidious_config="$HOME/invidious/"
invidious_last_run="$HOME/.cache/invidious_last_run"
freetube_cmd="io.freetubeapp.FreeTube"

token_mode=$1

function token_generator() {
  local today
  today=$(date +%Y-%m-%d)

  if [[ -f "$invidious_last_run" ]] && grep -q "$today" "$invidious_last_run"; then
    return 1
  fi

  echo "$today" >"$invidious_last_run"
  return 0
}

function startup() {
  if podman ps | grep -q "invidious"; then
    echo "Invidious Instance is already running."
  else
    cd "$invidious_config" || {
      notify-send -u critical "Invidious" "An error occurred"
      exit 1
    }

    # To disable token cycling, use the "disable" argument,
    # while passing the freetub.sh.
    # E.g. ./freetube.sh disable
    if [ "$token_mode" != "disable" ]; then
      echo "Token Cycling Skipped."
      if token_generator; then
        sh "$HOME/scripts/__invidious-token-generator.sh"
      fi
    fi

    podman-compose up -d
    echo "Invidious Instance launched."
    sleep 5
  fi
}

function main() {
  startup
  pgrep $freetube_cmd && hyprctl dispatch focuswindow class:$freetube_cmd || $freetube_cmd
}

main
