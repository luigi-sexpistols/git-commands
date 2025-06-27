#!/usr/bin/env bash

validate-branch () {
    local branch_name=$(cfg-branch $1)

    if [ "${branch_name}" = "" ]; then
        echo "Repository does not have a '$1' branch defined!"
        exit 1
    fi
}
