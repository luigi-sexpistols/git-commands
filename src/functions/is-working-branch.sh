is-working-branch () {
  branch="$1"

  if [ -z "$branch" ]; then
    return 0
  fi

  for b in 'develop' 'master'; do
    branch_name="$(git config "project.${b}branch")"

    if [ "$branch" == "$branch_name" ]; then
      return 1
    fi
  done

  return 0
}
