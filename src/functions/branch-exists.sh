branch-exists () {
    branch_name=$1
    
    if [ "$(git branch --list | grep -Eo "^\*?\s*${branch_name}$")" == "" ]; then
        return 1
    fi

    return 0
}