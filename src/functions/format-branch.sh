format-branch () {
  # todo - use a different token like {} or printf maybe?
  cfg-branch-format "$1" | sed "s|{ticketid}|$2|g"
}
