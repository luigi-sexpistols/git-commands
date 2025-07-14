set -e

src=$(realpath "$0" | xargs dirname)

for f in "$src"/functions/*.sh; do
    [ -e "$f" ] || break
    # shellcheck source=src/functions/
    source "$f"
done

for f in "$src"/config/*.sh; do
    [ -e "$f" ] || break
    # shellcheck source=src/config/
    source "$f"
done

for f in "$src"/validation/*.sh; do
    [ -e "$f" ] || break
    # shellcheck source=src/validations/
    source "$f"
done
