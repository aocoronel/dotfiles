#!/usr/bin/env bash

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
" >$path && echo "$file has been written to $path"
}

run
