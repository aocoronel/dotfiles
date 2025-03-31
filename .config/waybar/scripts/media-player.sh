#!/bin/env bash

TITLE=$(playerctl metadata --format '{{xesam:title}}' 2>/dev/null)
ARTIST=$(playerctl metadata --format '{{xesam:artist}}' 2>/dev/null)
STATUS=$(playerctl status 2>/dev/null)

tooltip=$"Title: ${TITLE:-Unknown}"
tooltip+=$"\nArtist: ${ARTIST:-Unknown}"

if [ -z "$STATUS" ]; then
  echo "No media playing"
  exit 1
else
  echo "{\"text\": \" ${TITLE:-No Title}\", \"tooltip\": \"$tooltip\"}"
fi
