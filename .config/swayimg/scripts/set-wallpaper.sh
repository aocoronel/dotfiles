#!/bin/env bash

file=$1

swww img --transition-type=fade "$file"

if [ ! -f $filename ]; then
	touch $filename
fi

echo "$file" >$HOME/.config/wall && exit
