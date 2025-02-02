#!/bin/env bash

image=$1

imageformat=$(echo "$image" | awk -F '.' '{print $NF}')

tempfile=$(mktemp --suffix=.png)

magick "$image" "$tempfile"

echo "Temporary file created: $tempfile"

trap "rm -f '$tempfile'" EXIT

wl-copy -t image/png <"$tempfile"
