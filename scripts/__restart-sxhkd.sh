#!/bin/env bash

pkill sxhkd
tmux kill-session -t key
tmuxp load key -d
