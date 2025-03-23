#!/usr/bin/env bash

select_client() {
  local clients="$1"
  local total_clients="$2"

  rofi -dmenu -i -no-levenshtein-sort -width 1000 -p "$total_clients" -mesg "${HELP}" -kb-custom-1 "${delete}" <<<"$clients"
}

get_client_address() {
  local client_name="$1"
  hyprctl clients -j | jq -r ".[] | select(.title == \"$client_name\") | .address"
}

close_client() {
  local client_address="$1"
  hyprctl dispatch closewindow address:"$client_address" && notify-send -u low "Rofi" "$client_name closed"
}

help_color="#7c5cff"
label="#f067fc"

delete="Ctrl+q"

total_clients=$(hyprctl clients -j | jq -r ".[].title" | wc -l)
clients=$(hyprctl clients -j | jq -r '.[] | "\(.title)"')

HELP="<span color='${label}'>Actions: </span><span color='${help_color}'>${delete}</span>: Close"

if [ "$total_clients" -eq 0 ]; then
  echo "No clients found."
  exit 1
fi

client_name=$(select_client "$clients" "$total_clients" "$HELP" "$delete")
val=$?

case "$val" in
0)
  client_address=$(get_client_address "$client_name")

  if [ -z "$client_address" ]; then
    echo "Client not found."
    exit 1
  fi

  hyprctl dispatch focuswindow address:"$client_address"
  ;;
10)
  if [ -n "$client_name" ]; then
    client_address=$(get_client_address "$client_name")
    if [ -n "$client_address" ]; then
      close_client "$client_address"
      echo "Closed client: $client_name"
    else
      echo "Client not found."
      exit 1
    fi
  else
    echo "No client selected to close."
    exit 1
  fi
  ;;
*)
  echo "No action taken."
  exit 1
  ;;
esac
