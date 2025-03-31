#!/bin/env bash

while true; do
  STATUS=$(playerctl status 2>/dev/null)

  if [ -z "$STATUS" ]; then
    echo "No media playing"
    continue
    sleep 10s
  fi

  TITLE=$(playerctl metadata --format '{{xesam:title}}' 2>/dev/null)
  ARTIST=$(playerctl metadata --format '{{xesam:artist}}' 2>/dev/null)

  tooltip=$"Title: ${TITLE:-Unknown}"
  tooltip+=$"\nArtist: ${ARTIST:-Unknown}"

  echo "{\"text\": \"${TITLE:-No Title}\", \"tooltip\": \"$tooltip\"}"

  sleep 5s
done
