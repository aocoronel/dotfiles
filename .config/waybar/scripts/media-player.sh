#!/bin/env bash

STATUS=$(playerctl status 2>/dev/null)

if [ -z "$STATUS" ]; then
  echo "No media playing"
  sleep 10s
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

sleep 5s
