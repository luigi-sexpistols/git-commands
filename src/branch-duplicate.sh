#!/usr/bin/env bash

. "$(echo $0 | xargs realpath | xargs dirname)/globals.sh"

branch_type=$1
ticket_id_old=$2
ticket_id_new=$3

validate-branching-config $branch_type

source_branch=$(format-branch $branch_type $ticket_id_old)
target_branch=$(format-branch $branch_type $ticket_id_new)

if ! branch-exists $source_branch; then
    echo "Branch '$source_branch' does not exist!"
    exit 1
fi

if branch-exists $target_branch; then
    echo "Branch '$target_branch' already exists!"
    exit 1
fi

if true; then
    "${src}/branch-checkout.sh" $branch_type $ticket_id_old
    git checkout -b $target_branch
else
    echo "Source branch: $source_branch"
    echo "Target branch: $target_branch"
fi