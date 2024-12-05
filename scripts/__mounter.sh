#!/bin/env bash

# Help Menu
function help() {
  echo "External Device Mounter"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "open [drive_name]             - Open luks device and mount it to /mnt/drive_name"
  echo "close [drive_name]            - Closes luks device and umount it"
}

function mount() {
  device=$(ls /dev | grep -E "sd[a-z]+[0-9]+$" | fzf --prompt "Choose a drive to mount")
  read -p "Name the drive: " drive
  sudo cryptsetup luksOpen /dev/$device $drive && echo "$device has been opened and named as $drive!"
  if [ ! -d "/mnt/$drive" ]; then
      echo "No directory found at /mnt/$drive. Creating one now..."
      sudo mkdir /mnt/$drive
      echo "Directory /mnt/$drive created."
  fi
  sudo mount /dev/mapper/$drive /mnt/$drive/ && echo "$drive has been mounted to /mnt/$drive!"
} 

function umount() {
  drive=$(ls /dev/mapper/ | fzf --prompt "Choose a drive to umount: ")
  sudo umount /mnt/$drive/
  sudo cryptsetup luksClose $drive && echo "$drive has been umounted!"
}

case $1 in
  "")
    help
    ;;
  "open")
    mount
    ;;
  "close")
    umount
    ;;
esac
