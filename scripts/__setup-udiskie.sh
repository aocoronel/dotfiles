#!/bin/env bash

# Help Menu
function help() {
  echo "Udiskie Setup"
  echo "Usage: $0 [option]"
  echo "Available options:"
  echo "run                                   - Writes configuration files to /etc/polkit-1/rules.d/50-udiskie.rules"
}

file=50-udiskie.rules
path=/etc/polkit-1/rules.d/50-udiskie.rules

function run() {
echo "
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        if (action.id.startsWith("org.freedesktop.udisks2.")) {
            return polkit.Result.YES;
        }
    }
});
" > $path && echo "$file has been written to $path"
}

case "$1" in
  "")
    help
    ;;
  "run")
    run
    ;;
esac
