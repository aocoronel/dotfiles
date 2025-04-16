#!/usr/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__sync-external.sh

HOSTNAME="$(hostnamectl hostname)"
NOW="$(date +%Y-%d-%H%M)"

function help() {
  cat <<EOF
Sync Tool for External Drives
Usage: $0 [command]
Available commands:
create                             - Use borg to backup
list                               - List all borg backups
mount                              - Mount borg
rsync                              - Use rsync to sync source directory to dest directory
Note: For borg, the source directory means the borg repository
EOF
}

function get_drives() {
  sourceonly=$1
  sourcedrive=$(ls /mnt/ | fzf --prompt "Choose directory you to copy from: " --preview 'eza -l /mnt/{}')
  if [ -z "$sourcedrive" ]; then
    echo "No source directory chosen!"
    exit 1
  fi
  if [ "$sourceonly" != "true" ]; then
    destdrive=$(ls /mnt/ | fzf --prompt "Choose directory to mirror to $sourcedrive: " --preview 'eza -l /mnt/{}')
    if [ -z "$destdrive" ]; then
      echo "No dest directory chosen!"
      exit 1
    fi
  fi
}

function is_borg() {
  if ls "/mnt/$sourcedrive" | grep "nonce"; then
    echo "This is a borg repository!"
    exit 0
  fi
  if ls "/mnt/$destdrive" | grep "nonce"; then
    echo "This is a borg repository!"
    exit 0
  fi
}

function sync_external() {
  # beelzebub is a directory I do not want to overwrite accidentally
  # better safe than sorry
  if [ "$destdrive" = "beelzebub" ]; then
    echo "Caution!"
    echo "The beelzebub directory have been selected as destdrive"
    exit 1
  else
    rsync --progress -avh --delete "/mnt/$sourcedrive/" /mnt/"$destdrive/"
  fi
}

function create_backup() {
  borg create --stats --progress "/mnt/$sourcedrive::$HOSTNAME-$NOW" "/mnt/$destdrive/"
}

function list_borg() {
  borg list "/mnt/$sourcedrive"
}

function mount_borg() {
  destdrive="$sourcedrive"_mount
  [[ ! -d "$destdrive" ]] && {
    mkdir -p "$destdrive"
    [[ ! -d "$destdrive" ]] && {
      echo "Failed to create directory!"
      exit 1
    }
  }
  borg mount "/mnt/$sourcedrive" "/mnt/$destdrive"
}

case "$1" in
mount)
  get_drives true # Source Only
  mount_borg
  exit 0
  ;;
list)
  get_drives true # Source Only
  list_borg
  exit 0
  ;;
create)
  get_drives
  create_backup
  exit 0
  ;;
rsync)
  get_drives
  is_borg
  sync_external
  exit 0
  ;;
*)
  help
  exit 0
  ;;
esac
