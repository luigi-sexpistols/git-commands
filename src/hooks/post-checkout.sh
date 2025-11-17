#!/usr/bin/env bash

here () {
  readlink -f "$0" | xargs realpath | xargs dirname | xargs dirname
}

source "$(here)"/config/branch-format.sh
source "$(here)"/functions/format-branch.sh
source "$(here)"/functions/is-working-branch.sh

post-checkout () {
  local \
    branch \
    branch_type \
    ticket_id

  branch="$1"

  if ! is-working-branch "$branch"; then
    echo "Not a working branch, skipping post-checkout hook."
    return 0
  fi

  # find a way to do this that doesn't assume the branch is in the format of "type/id" (e.g. GLUP used "ar-GLUP-1234")
  # could loop over the branch types and check if the branch starts with any of them?
  # make a function to get the branch type from the branch name?
  branch_type="$(echo "$branch" | sed -E 's|/.+$||')"

  if [ "$branch_type" == "" ]; then
    echo "Branch '$branch' does not have a valid type prefix!"
    return 1
  fi

  ticket_id="$(echo "$branch" | sed -E "s|$(format-branch "$branch_type" '')||g")"

  if [ "$ticket_id" == "" ]; then
    echo "Branch '$branch' does not have a valid ticket ID!"
    return 0
  fi

  git config "branch.${branch}.ticket-id" "$ticket_id"
}

post-checkout "$(git symbolic-ref --short HEAD)"
