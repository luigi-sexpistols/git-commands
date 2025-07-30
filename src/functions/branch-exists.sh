# returns 0 if branch exists in origin, 1 if not, 2 for error
branch-exists-local () {
  local branch_name="$1"

  if [ -z "$branch_name" ]; then
    echo "Error: Branch name is required."
    return 2
  fi

  if [ "$(git branch --list "$branch_name")" == "" ]; then
    return 1
  fi

  return 0
}

# returns 0 if branch exists in origin, 1 if not, 2 for error
branch-exists-origin () {
  local branch_name="$1"

  if [ -z "$branch_name" ]; then
    echo "Error: Branch name is required."
    return 2
  fi

  if [ "$(git branch --remotes --list "origin/$branch_name")" == "" ]; then
    return 1
  fi

  return 0
}

branch-exists () {
  local branch_name="$1"

  if branch-exists-local "$branch_name"; then
    cry "Branch '${branch_name}' exists locally."
    return 0
  fi

  if branch-exists-origin "$branch_name"; then
    cry "Branch '${branch_name}' exists in origin."
    return 0
  fi

  cry "Branch '${branch_name}' does not exist in local or origin."
  return 1
}
