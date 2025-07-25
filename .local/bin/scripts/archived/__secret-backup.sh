#!/usr/bin/env bash

pubkeys="$PWD/public.keys.gpg"
privatekeys="$PWD/private.keys.gpg"
tarball="$HOME/gpg.tar.gz"
tomb_file=${PASSWORD_STORE_TOMB_FILE:-$HOME/.password.tomb}
tomb_key=${PASSWORD_STORE_TOMB_KEY:-$HOME/.password.tomb.key}

function error_check() {
  message="$1"
  val=$?
  if [ "$val" -eq 0 ]; then
    echo "All $message keys have been successfully exported!"
  else
    echo "Failed to export $message keys!"
    exit 1
  fi
}

function gpg_export() {
  gpg --export --armor >"$pubkeys"
  error_check pubkeys
  gpg --export-secret-keys --armor >"$privatekeys"
  error_check privatekeys
}

function gpg_import() {
  gpg --import "$pubkeys"
  gpg --import "$privatekeys"
}

function archive_encrypt() {
  tar czvf "$tarball" "$privatekeys" "$pubkeys" "$tomb_file" "$tomb_key"
  openssl enc -aes-256-cbc -e -in "$tarball" -out "$tarball.enc" -iter 10000
  srm "$HOME/gpg.tar"
}

function extract_decrypt() {
  openssl enc -aes-256-cbc -d -in "$tarball.enc" -out "$tarball" -iter 10000
  tar xzvf "$tarball"
}

while getopts ":g" opt; do
  case "$opt" in
  g)
    GPG_ONLY=true
    ;;
  ?)
    echo "Error: Invalid option '-$OPTARG'" >&2
    exit 1
    ;;
  esac
done

shift $((OPTIND - 1))

case "$1" in
"export")
  gpg_export
  if [ "$GPG_ONLY" != "true" ]; then
    archive_encrypt
  fi
  ;;
"import")
  if [ "$GPG_ONLY" != "true" ]; then
    extract_decrypt
  fi
  gpg_import
  ;;
*)
  echo "Usage:"
  echo "export               Export gpg keys and pass, encrypts over openssl"
  echo "import               Import gpg keys and pass"
  echo "Use -g flag for gpg operations only"
  ;;
esac
