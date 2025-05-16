#!/bin/env bash

STATUS=$(playerctl status 2>/dev/null)
val=$?

if [ "$val" -ne 0 ]; then
  echo "{\"text\": ""}"
  exit 0
fi

TITLE=$(playerctl metadata --format '{{xesam:title}}' 2>/dev/null)
ARTIST=$(playerctl metadata --format '{{xesam:artist}}' 2>/dev/null)

tooltip=$"Title: ${TITLE:-Unknown}"
tooltip+=$"\nArtist: ${ARTIST:-Unknown}"

if [ "$STATUS" == "Playing" ]; then
  echo "{\"text\": \" ${TITLE:-No media}\", \"tooltip\": \"$tooltip\"}"
else
  echo "{\"text\": \" ${TITLE:-No media}\", \"tooltip\": \"$tooltip\"}"
fi
