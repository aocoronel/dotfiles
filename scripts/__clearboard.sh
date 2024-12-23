#!/bin/env bash

function clearboard() {
  dunstctl close-all
  echo "" | xclip -sel clip
}

clearboard
