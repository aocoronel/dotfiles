#!/usr/bin/env bash

ssh_file="$HOME/.ssh/ssh_machines"

function help() {
  cat <<EOF
SSH Manager
Usage: $0 [option]
Available options:
cp   <remote_path> <local_path> <user>  - Copy file from remote
edit                                    - Edit ssh_machines file
config                                  - Edit ssh config file
git <git_cmd> <git_path> <user>         - Run any git command
help                                    - Displays this message and exits
in                                      - Select machine to SSH in
send <remote_path> <local_path> <user>  - Send file to remote
setup                                   - Copy SSH pubkey to server
EOF
}

function get_data() {
  machine=$(awk -F "::" '{print $1}' "$ssh_file" | fzf --prompt "Select your machine: ")
  get_full_ip=$(grep "$machine" <"$ssh_file" | awk -F "::" '{print $2}')
  ip=$(echo "$get_full_ip" | awk -F ":" '{print $1}')
  port=$(echo "$get_full_ip" | awk -F ":" '{print $2}')
}

function get_in() {
  user=${1:-}
  [[ -n "$user" ]] && user+=@
  if [ -z "$port" ]; then
    ssh -C "$user$ip"
  else
    ssh -C -p "$port" "$user$ip"
  fi
}

function edit_ssh() {
  editor=${EDITOR:-nvim}
  sh -c "$editor $ssh_file"
}

function config_ssh() {
  local ssh_config="$HOME/.ssh/config"
  editor=${EDITOR:-nvim}
  sh -c "$editor $ssh_config"
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
  user="${3:-}"

  if [ -n "$user" ]; then
    user+="@"
  fi
  source_path="${user}${ip}:${remote_path}"

  if [ -z "$port" ]; then
    scp "$source_path" "$local_path"
  else
    scp -P "$port" "$source_path" "$local_path"
  fi
}

function ssh_send() {
  remote_path="$1"
  local_path="$2"
  user="$3"

  ssh_cmd="ssh"
  if [ -n "$port" ]; then
    ssh_cmd+=" -p $port"
  fi

  if [ -n "$user" ]; then
    user+="@"
  fi
  source_path="${user}${ip}:${remote_path}"

  rsync -avz -e "$ssh_cmd" "$source_path" "$local_path"
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
config)
  config_ssh
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
  shift
  get_data
  ssh_cp "$1" "$2" "$3"
  exit 0
  ;;
send)
  shift
  get_data
  ssh_send "$1" "$2" "$3"
  exit 0
  ;;
help)
  help
  exit 0
  ;;
*)
  help
  exit 0
  ;;
esac
