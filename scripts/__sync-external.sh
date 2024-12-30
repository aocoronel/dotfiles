#!/bin/env bash

hostname="$(hostnamectl hostname)"
now="$(date +%Y-%H%M)"

function get_drives() {
sourcedrive=$(ls /mnt/ | fzf --prompt "Choose source directory: " --preview 'eza -l /mnt/{}')
if [ -z "$sourcedrive" ]; then
  echo "No source directory chosen!"
  exit 1
fi
destdrive=$(ls /mnt/ | fzf --prompt "Choose dest directory: " --preview 'eza -l /mnt/{}')
if [ -z "$destdrive" ]; then
  echo "No dest directory chosen!"
  exit 1
fi
}

function check_borg() {
  ls /mnt/$sourcedrive | grep "nonce"
  if [ "$?" -eq 0 ]; then
    echo "This is a borg repository!"
    exit 0
  fi
  ls /mnt/$destdrive | grep "nonce"
  if [ "$?" -eq 0 ]; then
    echo "This is a borg repository!"
    exit 0
  fi
}

function sync_external() {
  if [ "$destdrive" = "beelzebub" ]; then
    echo "Caution!"
    echo "The beelzebub directory have been selected as destdrive"
    exit 0
  else
    rsync -av --delete /mnt/"$sourcedrive/" /mnt/"$destdrive/"
  fi
}

function run_borg() {
  borg create --stats --progress /mnt/"$sourcedrive"::"$hostname"-"$now" "/mnt/$destdrive"
}

 function help() {
cat << EOF
Sync Tool for External Drives
Usage: $0 [option]
Available options:
-b                            - Use borg to backup
-s                            - Use rsync to sync source directory to dest directory
For borg, the source directory means the borg repository
EOF
}

if [[ "$1" == "-b" ]]; then
  get_drives
  run_borg
  exit 0
elif [[ "$1" == "-s" ]]; then
  get_drives
  check_borg
  sync_external
  exit 0
else
  help
  exit 0
fi
