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

function read_option() {
  while true; do
  read -p "Choose an option (open/close): " option
  if [ $option == "open" ]; then
    mount
  elif [ $option == "close" ]; then
    umount
  else
    echo "Choose open or close!"
  fi
done
}

case $1 in
  "help")
    help
    ;;
  "open")
    mount
    ;;
  "close")
    umount
    ;;
  "")
    read_option
    ;;
esac
