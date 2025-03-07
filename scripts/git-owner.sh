#!/bin/env bash

function help() {
  cat <<EOF
Disclaimer!

This script should be used very carefully, specially
in repositories where there are collaborators. This
means you should not run it in a collaborative repo!

This scripts can update user related data such as
- Username
- Email
- SigningKeys (GPG)

Use cases

- This is useful when you want to change your Github
account email, and remove the old one, and keep all
your commits being attributed to your account
- Sign all your commits with a more recent GPG key

Usage

- SigningKeys are used from the global or local config
- You must edit the apply function to your needs

To properly run this script run:
$0 apply

EOF
}

function apply() {
  git filter-branch -f --env-filter '
if [ "$GIT_AUTHOR_EMAIL" = "aocoronel@particular.slmail.me" ]
then
    GIT_AUTHOR_NAME="Augusto Coronel"
    GIT_AUTHOR_EMAIL="aoc@getgoogleoff.me"
fi
if [ "$GIT_COMMITTER_EMAIL" = "aocoronel@particular.slmail.me" ]
then
    GIT_COMMITTER_NAME="Augusto Coronel"
    GIT_COMMITTER_EMAIL="aoc@getgoogleoff.me"
fi
' --tag-name-filter cat -- --branches --tags

  git push --force --tags origin 'refs/heads/*'

  git filter-branch -f --commit-filter '
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" \
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL" \
GIT_COMMITTER_DATE="$GIT_AUTHOR_DATE" \
git commit-tree -S "$@"' HEAD

  git push --force --tags origin 'refs/heads/*'
}

case "$1" in
"apply")
  apply
  ;;
*)
  help
  ;;
esac
