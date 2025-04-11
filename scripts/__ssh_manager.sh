#!/usr/bin/env bash

shell=$(basename "$SHELL") # Required for NixOS

ssh_file="$HOME/.ssh/ssh_machines"
sh_profile="$HOME/.$shell"_profile

if [ ! -f "$sh_profile" ]; then
  echo "Shell Profile is required!"
  echo "You must create a .$shell'_profile' at $HOME"
  exit 1
fi

function help() {
  cat <<EOF
SSH Manager
Usage: $0 [option]
Available options:
cp   <remote_path> <local_path> <user>  - Copy file from remote
edit                                    - Edit ssh_machines file
git <git_cmd> <git_path> <user>         - Run any git command
help                                    - Displays this message and exits
in                                      - Select machine to SSH in
send <remote_path> <local_path> <user>  - Send file to remote
setup                                   - Copy SSH pubkey to server
EOF
}

function ssh_add() {
  source "$sh_profile"
}

function get_data() {
  ssh_add

  machine=$(awk -F "::" '{print $1}' "$ssh_file" | fzf --prompt "Select your machine: ")
  get_full_ip=$(grep "$machine" <"$ssh_file" | awk -F "::" '{print $2}')
  ip=$(echo "$get_full_ip" | awk -F ":" '{print $1}')
  port=$(echo "$get_full_ip" | awk -F ":" '{print $2}')
}

function get_in() {
  user=${1:-}
  [[ -n "$user" ]] && user+=@
  if [ -z "$port" ]; then
    ssh "$user$ip"
  else
    ssh -p "$port" "$user$ip"
  fi
}

function edit_ssh() {
  editor=${EDITOR:-nvim}
  sh -c "$editor $ssh_file"
}

function setup_ssh() {
  user=${1:-}
  [[ -n "$user" ]] && user+=@
  if [ -z "$port" ]; then
    ssh-copy-id "$user$ip"
  else
    ssh-copy-id -P "$port" "$user$ip"
  fi
}

function ssh_cp() {
  remote_path="$1"
  local_path="$2"
  user=${3:-}
  [[ -n "$user" ]] && user+=@
  if [ -z "$port" ]; then
    scp "$user$ip:$remote_path" "$local_path"
  else
    scp -P "$port" "$user$ip:$remote_path" "$local_path"
  fi
}

function ssh_send() {
  remote_path="$1"
  local_path="$2"
  user=$3
  [[ -n "$user" ]] && user+=@
  if [ -z "$port" ]; then
    rsync -avz "$user$ip:$remote_path" "$local_path"
  else
    rsync -avz --port="$port" "$user$ip:$remote_path" "$local_path"
  fi
}

function ssh_git() {
  git_cmd="$1"
  git_path="$2"
  user="$3"
  [[ -z "$git_cmd" ]] && {
    echo "Not git command provided!"
    exit 1
  }
  if [ -n "$user" ]; then
    if [ -z "$port" ]; then
      git "$git_cmd" ssh://"$user""@""$ip$git_path"
    else
      git "$git_cmd" ssh://"$user""@""$ip":"$port""$git_path"
    fi
  else
    if [ -z "$port" ]; then
      git "$git_cmd" ssh://"$ip$git_path"
    else
      git "$git_cmd" ssh://"$ip":"$port""$git_path"
    fi
  fi
}

case "$1" in
in)
  shift
  get_data
  get_in "$1"
  exit 0
  ;;
edit)
  edit_ssh
  exit 0
  ;;
setup)
  shift
  get_data
  setup_ssh "$1"
  exit 0
  ;;
git)
  shift
  get_data
  ssh_git "$1" "$2" "$3"
  exit 0
  ;;
cp)
  get_data
  ssh_cp "$1" "$2" "$3"
  exit 0
  ;;
send)
  get_data
  ssh_send "$1" "$2" "$3"
  exit 0
  ;;
help)
  help
  ;;
*)
  help
  ;;
esac
