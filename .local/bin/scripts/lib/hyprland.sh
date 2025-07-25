#!/usr/bin/env bash

function focus() {
  client_short_name="$1"
  client_true_name=$(hyprctl clients -j | jq -r '.[] | "\(.title)"' | grep "$client_short_name")

  client_address=$(hyprctl clients -j | jq -r ".[] | select(.title == \"$client_true_name\") | .address")

  if [ -z "$client_address" ]; then
    echo "Client not found."
    exit 1
  fi

  hyprctl dispatch focuswindow address:"$client_address"
}
