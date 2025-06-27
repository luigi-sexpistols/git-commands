#!/usr/bin/env bash

. "$(echo $0 | xargs realpath | xargs dirname)/globals.sh"

branch_type=$1

validate-branch "${branch_type}"

branch_name=$(cfg-branch $branch_type)

if ! branch-exists "$branch_name"; then
    echo "Branch '$branch_name' does not exist!"
    exit 1
fi

if true; then
    git checkout "$branch_name"
    git pull
else
    echo "Branch to pull: $branch_name"
fi
