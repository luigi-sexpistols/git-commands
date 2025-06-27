validate-branching-config () {
    local branch_type=$1
    local branch_from_type=$(cfg-branch-from $branch_type)

    if [ "${branch_from_type}" = "" ]; then
        echo "Repository is not set up for '${branch_type}' branches!"
        exit 1
    fi

    validate-branch $branch_from_type
}