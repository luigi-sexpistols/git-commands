#!/usr/bin/env bash

. "$(echo $0 | xargs realpath | xargs dirname)/globals.sh"

branch_type=$1
ticket_id_old=$2
ticket_id_new=$3

if [ "${ticket_id_old}" == "${ticket_id_new}" ]; then
    echo 'Old and new branches are the same, exiting gracefully...'
    exit 0
fi

validate-branching-config "${branch_type}"

branch_old=$(format-branch $branch_type $ticket_id_old)
branch_new=$(format-branch $branch_type $ticket_id_new)

if ! branch-exists "${branch_old}"; then
    echo "Branch '${branch_old}' does not exist!"
    exit 1
fi

if branch-exists "${branch_new}"; then
    echo "Branch '${branch_new}' already exists!"
    exit 1
fi

if true; then
    git branch "${branch_old}" -m "${branch_new}"
else
    echo "Old branch: $branch_old"
    echo "New branch: $branch_new"
fi