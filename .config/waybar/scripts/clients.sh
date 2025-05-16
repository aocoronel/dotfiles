#!/usr/bin/env bash

# Known bug:
# If a window name has "&", the tooltip won't show up

FLAG=$1
FLAG_CACHE=$HOME/.cache/waybar-client

tooltip="LMB: Clients"
tooltip+="\nRMB: Workspace"

function get_clients() {
  total_clients=$(hyprctl clients -j | jq -r ".[].title" | wc -l)
  client_names=$(hyprctl clients -j | jq -r '.[] | "\(.workspace.id) | \(.title)"')

  tooltip+="\n\nRunning Clients: $total_clients"
  tooltip+="\n\nClients:"

  while IFS= read -r client; do
    tooltip+="\n$client"
  done <<<"$client_names"

  text=$total_clients
  icon=󰣆
}

function get_workspace() {
  workspace=$(hyprctl activeworkspace | sed -n 's/.*(\([^)]*\)).*/\1/p')
  tooltip+="\n\nCurrent Workspace: $workspace"
  text=$workspace
  icon=
}

function save_flag() {
  echo "$FLAG" >"$FLAG_CACHE"
}

function _return() {
  echo "{\"text\": \"$icon  $text\", \"tooltip\": \"$tooltip\"}"
}

function main() {
  if [ -n "$FLAG" ]; then
    save_flag
  fi
  case "$(cat "$FLAG_CACHE")" in
  workspace)
    get_workspace
    ;;
  *)
    get_clients
    ;;
  esac
  _return
}

main "$FLAG"
