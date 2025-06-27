set-ticket-id-if-missing () {
    local branch="$1"
    local ticket_id="$2"
    local existing_value=$(git config "branch.${branch}.ticket-id")

    if [ "$existing_value" == "$ticket_id" ]; then
        return 0
    fi

    git config "branch.${branch}.ticket-id" "$ticket_id"
}
