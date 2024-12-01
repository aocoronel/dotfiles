#!/bin/env bash

# Help Menu

function help() {
  echo "Pacman packages backup creator and installer"
  echo "Usage: $0 [option]"
  echo "Important: This script requires yay as AUR Helper"
  echo "Available options:"
  echo "bak                                  - Create a backup of installed packages to $HOME/"
  echo "install                              - Install pacman packages and AUR packages from backup file"
  echo "help                                 - Display this message and exits"
}

arch=("$HOME/pacman-install-pkgs $HOME/pacman-aur $HOME/pacman-error")

function backup() {
  # Prints all explicitly installed packages to file
  pacman -Qe | awk '{print $1}' > $HOME/pacman-pkgs
}

function install() {
  comm -23 <(sort $HOME/pacman-pkgs) <(sort $HOME/pacman-aur) > $HOME/pacman-install-pkgs
  echo "Installing pacman packages"
  # Install packages latest version
  sudo pacman -S - < $HOME/pacman-install-pkgs || echo "Install was cancelled, or an error occurred!"
  echo "Installing AUR packages"
  yay -S - < $HOME/pacman-aur || echo "Install was cancelled, or an error occurred!"
  rm -r "${arch[@]}"
  exit 0
}

function grab_aur_packages() {
  # Separate pacman packages from AUR packages
  sudo pacman -S - < $HOME/pacman-pkgs 2>&1 | tee $HOME/pacman-error | grep -i "error:" | awk '{print $5}' > pacman-aur
  if [ $? -ne 1 ]; then
    echo "Make a backup first!"
    exit 0
  else
    install
  fi
}

case "$1" in
  "")
    help
    ;;
  "bak")
    backup
    ;;
  "install")
    grab_aur_packages
    ;;
esac
