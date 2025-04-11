#!/usr/bin/env bash

shell=$(basename "$SHELL") # Required for NixOS

ssh_file="$HOME/.ssh/ssh_machines"
sh_profile="$HOME/.$shell"_profile

if [ -f "$sh_profile" ]; then
  source "$sh_profile"
else
  echo "Shell Profile is required!"
  echo "You must create a .$shell'_profile' at $HOME"
  exit 1
fi

function help() {
  cat <<EOF
SSH Manager
Usage: $0 [option]
Available options:
help                    - Displays this message and exits
in                      - Select machine to SSH in
EOF
}

function get_in() {
  machine=$(awk -F "::" '{print $1}' "$ssh_file" | fzf --prompt "Select your machine: ")

  get_full_ip=$(grep "$machine" <"$ssh_file" | awk -F "::" '{print $2}')

  ip=$(echo "$get_full_ip" | awk -F ":" '{print $1}')
  port=$(echo "$get_full_ip" | awk -F ":" '{print $2}')

  if [ -z "$port" ]; then
    ssh "$ip"
  else
    ssh -p "$port" "$ip"
  fi
}

case "$1" in
in)
  get_in
  exit 0
  ;;
help)
  help
  ;;
esac
