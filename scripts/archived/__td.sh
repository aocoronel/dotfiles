#!/usr/bin/env bash

function add_tasks() {
  local project=""
  local tasks_with_tags=()

  while (($#)); do
    if [[ $1 == project:* ]]; then
      project="${1#project:}"
    elif [[ $1 == tags:* ]]; then
      tags="${1#tags:}"
      shift
      tasks_with_tags+=("$tags|$1")
    else
      task_name="$1"
      tasks_with_tags+=("None|$task_name")
    fi
    shift
  done

  if [[ -z $project || ${#tasks_with_tags[@]} -eq 0 ]]; then
    echo "Usage: project:<project_name> [tags:<tag>] <task_name1> <task_name2> ..."
    exit 1
  fi

  for task_with_tags in "${tasks_with_tags[@]}"; do
    IFS='|' read -r tags task_name <<<"$task_with_tags"

    task_args="project:$project"
    if [[ $tags != "None" ]]; then
      task_args="$task_args tags:$tags"
    fi

    task add "$task_args" "$task_name"
  done
}

add_tasks "$@"
