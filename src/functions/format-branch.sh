format-branch () {
  cfg-branch-format "$1" | sed "s|{ticketid}|$2|g"
}
