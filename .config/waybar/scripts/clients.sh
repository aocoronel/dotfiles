#!/usr/bin/env bash

total_clients=$(hyprctl clients -j | jq -r ".[].title" | wc -l)

client_names=$(hyprctl clients -j | jq -r '.[] | "\(.workspace.id) | \(.title)"')

tooltip="Running Clients: $total_clients"
tooltip+="\n\nClients:"

while IFS= read -r client; do
  tooltip+="\n$client"
done <<<"$client_names"

echo "{\"text\": \"󰣆  $total_clients\", \"tooltip\": \"$tooltip\"}"
