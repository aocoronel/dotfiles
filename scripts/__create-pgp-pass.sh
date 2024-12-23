#!/bin/env bash

function create_pass() {
  read -p "Name your file to be saved: " filename
  while true; do
    echo "Enter the password you want to protect:"
    read -s pass
    echo "Please, retype your password:"
    read -s pass2
    if [ "$pass" = "$pass2" ]; then
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
    else
      echo "The passwords don't match!"
    fi
  done
}

function email_checker() {
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

email_checker
