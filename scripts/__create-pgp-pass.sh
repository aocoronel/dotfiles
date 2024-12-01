#!/bin/env bash

# Help Menu

function help() {
  echo "Password protect over Pretty Good Privacy"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "help                                   - Displays this message and exits"
}

function create_pass() {
  read -p "Name your file to be saved: " filename
  read -p "Enter the password you want to protect: " pass
  echo "$pass" | gpg --encrypt -a --recipient $email > $filename.asc
  if [ $? -ne 0 ]; then
    echo "Something wrong happened!"
    set -o history
    exit 1
  else 
    echo "Your pgp file $filename.asc has been created successfuly!"
    set -o history
    exit 0
  fi
}

function email_checker() {
  # Turns off history for privacy
  set +o history
  echo "Generating your pgp protected password"
  read -p "Enter your email: " email
  gpg --list-keys | grep -q "$email"
  if [ $? -eq 1 ]; then
    echo "$email doesn't have a gpg key associated to it!"    
    read -p "Do you want to create one now? (y/n): " choice
    while true; do
      if [ "$choice" == "y" ]; then
        read -p "Enter name associated to your email (e.g. John Doe): " name
        gpg --quick-generate-key "$name $email" rsa encrypt 1y
        if [ $? -ne 0 ]; then
          set -o history
          echo "An error occured!"
          exit 1
        else
          echo "Your gpg key was created successfuly!"
          echo "Your new gpg key is set to expire in 1 year"
          create_pass
        fi
      elif [ "$choice" == "n" ]; then
        set -o history
        exit 0
      else
        echo "Please, enter y or n: "
      fi
    done
  else
    create_pass
  fi
}

case "$1" in
  "help")
    help
    ;;
  "")
    email_checker
    ;;
esac
