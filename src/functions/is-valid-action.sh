is-valid-action () {
    local given="$1"

    for allowed in '' 'config' 'hooks'; do
        [ "$allowed" == "$given" ] && return 0
    done

    return 1
}
