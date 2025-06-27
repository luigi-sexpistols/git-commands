#!/usr/bin/env bash

. "$(echo $0 | xargs realpath | xargs dirname)/globals.sh"

target_branch_type=$1
ticket_id=$2

validate-branching-config "${target_branch_type}"

source_branch_type=$(cfg-branch-from $target_branch_type)
source_branch=$(cfg-branch $source_branch_type)
target_branch=$(format-branch $target_branch_type $ticket_id)

if branch-exists "${target_branch}"; then
    echo "Branch '${target_branch}' already exists!"
    exit 1
fi

if true; then
    git checkout "${source_branch}"
    git pull
    git checkout -b "${target_branch}"

    set-ticket-id-if-missing "${target_branch}" "$ticket_id"
else
    echo "Source branch: $source_branch"
    echo "Target branch: $target_branch"
fi
