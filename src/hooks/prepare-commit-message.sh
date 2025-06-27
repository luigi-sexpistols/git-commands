#!/usr/bin/env bash

config_key='project.commitprefix'

prepare-commit-message () {
    local input_file="$1"
    local format=$(git config "$config_key")

    if [ -n "$commit_prefix" ]; then
        local branch=$(git symbolic-ref --short HEAD)
        local ticket_id=$(git config "branch.${branch}.ticket-id")
        local prefix=$(echo "$format" | sed "s/{ticketid}/${ticket_id}/g")

        echo "${prefix} $(cat "$input_file")"
    else
        cat "$input_file"
    fi
}

prepare-commit-message "$1" > "$1"
