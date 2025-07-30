cry() { echo "$(basename "$0"): $*" >&2; }
die() { cry "$1"; exit $2; }
try() { "$@" || die "cannot $*" $?; }
