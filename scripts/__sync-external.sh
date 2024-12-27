#!/bin/env bash

hostname="$(hostnamectl hostname)"
now="$(date +%Y-%H%M)"

function get_drives() {
sourcedrive=$(ls /mnt/ | fzf --prompt "Choose source directory: ")
if [ -z "$sourcedrive" ]; then
  echo "No source directory chosen!"
  exit 1
fi
destdrive=$(ls /mnt/ | fzf --prompt "Choose dest directory: ")
if [ -z "$destdrive" ]; then
  echo "No source directory chosen!"
  exit 1
fi

}
function sync_external() {
  rsync -av --delete "$sourcedrive" "$destdrive"
}

function run_borg() {
  borg create --stats --progress /mnt/"$sourcedrive"::"$hostname"-"$now" "$destdrive"
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
  sync_external
  exit 0
else
  help
  exit 0
fi
