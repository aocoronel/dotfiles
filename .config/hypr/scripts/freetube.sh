#!/bin/env bash

invidious_config=$HOME/invidious/

function startup() {
  if podman ps | grep -q "invidious"; then
    echo "Invidious Instance is already running."
  else
    cd "$invidious_config" || {
      notify-send -u critical "Invidious" "An error occurred"
      exit 1
    }
    sh "$HOME/scripts/__invidious-token-generator.sh"
    podman-compose up -d
    echo "Invidious Instance launched."
    sleep 5
  fi
}

function main() {
  startup
  freetube
}

main
