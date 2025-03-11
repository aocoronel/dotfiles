#!/usr/bin/env bash

function umount_dir() {
  fusermount -u $BEELZEBUB
  val=$?
}

podman stop --all
umount_dir

if [ "$val" -ne 0 ]; then
  echo "Umounting failed..."
  echo "Working around this problem"
  tmux kill-server
  fusermount
fi

if [ "$val" -ne 0 ]; then
  echo "Issue persists..."
  echo "Manual intervention required!"
fi

if [ "$val" -eq 0 ]; then
  echo "Everything seems OK"
  echo "Inspect Directory:"
  lsof $BEELZEBUB
  echo "Leave now? (y/N)"
  read leave
  if [ "$leave" = "y" ]; then
    poweroff
  else
    exit 1
  fi
fi
