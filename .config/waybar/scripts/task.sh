#!/bin/bash

tasks=$(task status:pending count)

if [ -z "$tasks" ]; then
	echo '{"text": "No tasks", "class": "no-tasks"}'
else
	echo "{\"text\":\"$tasks tasks\", \"class\":\"taskwarrior\"}"
fi
