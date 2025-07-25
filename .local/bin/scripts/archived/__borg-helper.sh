#!/usr/bin/env bash

HOSTNAME="$(hostnamectl hostname)"
NOW="$(date +%Y-%d-%H%M)"
MOUNT_POINT="/mnt"
BORG_REPO_INDICATOR="nonce"
EXCLUDED_DIR="beelzebub"

function help() {
  cat <<EOF
Borg Helper Tool

Usage:
  borg-helper COMMAND

Commands:
  borg <BORG_COMMAND>              Run any borg command (local)
  create-remote <PATH/TO/BACKUP>   Use borg to local backup
  create                           Use borg to local backup
  mount                            Mount borg
  remote <BORG_COMMAND>            Run any borg command (remote)
EOF
}

function get_drive() {
  local prompt=$1
  local drive
  drive=$(ls "$MOUNT_POINT" | fzf --prompt "$prompt" --preview "eza -l $MOUNT_POINT/{}")
  if [ -z "$drive" ]; then
    echo "No directory chosen!"
    exit 1
  fi
  echo "$drive"
}

function get_drives() {
  sourceonly=$1
  sourcedrive=$(get_drive "Choose directory you to copy from: ")
  if [ "$sourceonly" != "true" ]; then
    destdrive=$(get_drive "Choose directory to mirror to $sourcedrive: ")
  fi
}

function is_borg_repo() {
  local drive=$1
  if ls "$MOUNT_POINT/$drive" | grep -q "$BORG_REPO_INDICATOR"; then
    echo "This is a borg repository!"
    return 0
  fi
  return 1
}

function sync_external() {
  if [ "$destdrive" = "$EXCLUDED_DIR" ]; then
    echo "Caution!"
    echo "The $EXCLUDED_DIR directory has been selected as destdrive"
    exit 1
  fi
  rsync --progress --delete "$MOUNT_POINT/$sourcedrive/" "$MOUNT_POINT/$destdrive/"
}

function create_backup() {
  borg create --stats --progress "$MOUNT_POINT/$sourcedrive::$HOSTNAME-$NOW" "$MOUNT_POINT/$destdrive/"
}

function remote_backup() {
  local remote dest_path
  dest_path="$1"
  remote=$(cat ~/.ssh/borg_server)
  borg create --stats --progress "$remote::$HOSTNAME-$NOW" "$dest_path"
}

function cmd_borg() {
  local cmd=$1
  borg "$cmd" "$MOUNT_POINT/$sourcedrive"
}

function remote_borg() {
  local cmd=$1
  local remote
  remote=$(cat ~/.ssh/borg_server)
  borg "$cmd" "$remote"
}

function mount_borg() {
  local mount_dir="${sourcedrive}_mount"
  if [ ! -d "$MOUNT_POINT/$mount_dir" ]; then
    mkdir -p "$MOUNT_POINT/$mount_dir" || {
      echo "Failed to create directory!"
      exit 1
    }
  fi
  borg mount "$MOUNT_POINT/$sourcedrive" "$MOUNT_POINT/$mount_dir"
}

case "$1" in
mount)
  get_drives true # Source Only
  mount_borg
  exit 0
  ;;
borg)
  shift
  get_drives true
  cmd_borg "$@"
  exit 0
  ;;
remote)
  shift
  remote_borg "$@"
  exit 0
  ;;
create-remote)
  shift
  remote_backup "$@"
  exit 0
  ;;
create)
  get_drives
  create_backup
  exit 0
  ;;
rsync)
  get_drives
  if is_borg_repo "$sourcedrive" || is_borg_repo "$destdrive"; then
    exit 1
  fi
  sync_external
  exit 0
  ;;
*)
  help
  exit 0
  ;;
esac
