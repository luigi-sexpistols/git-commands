#!/usr/bin/env bash

enable_debugging="$2"
#enable_debugging="gcp-debug"

log () {
  [ "$enable_debugging" = 'gcp-debug' ] || return 0

  echo "$1" >&2
}

prepare-commit-message () {
    local input_file="$1"
    local \
      format \
      branch \
      ticket_id \
      prefix \
      message

    format="$(git config project.commitprefix)"
    message="$(<"$input_file")"

    log "Input file: $input_file"
    log "Format: $format"
    log "Message: $message"

    if [ -n "$format" ]; then
        branch=$(git symbolic-ref --short HEAD)
        ticket_id=$(git config "branch.${branch}.ticket-id")
        prefix="${format//'{ticketid}'/"$ticket_id"}"

        log "Branch: $branch"
        log "Ticket ID: $ticket_id"
        log "Prefix: $prefix"

        message="${prefix} ${message}"
    fi

    log "Final commit message: ${message}"
    echo "$message"
}

prepare-commit-message "$1" > /tmp/gpc-commit-msg
mv /tmp/gpc-commit-msg "$1"
