#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
TARGET="$BIN_DIR/reset-wifi"
OLD_TARGET="$BIN_DIR/update-wifi"
ZSHRC="$HOME/.zshrc"
OLD_MARKER_START="# >>> update-wifi shortcut >>>"
OLD_MARKER_END="# <<< update-wifi shortcut <<<"
SHORTCUT_MARKER_START="# >>> reset-wifi shortcut >>>"
SHORTCUT_MARKER_END="# <<< reset-wifi shortcut <<<"

remove_block() {
  local start="$1" end="$2"
  if [[ ! -f "$ZSHRC" ]] || ! grep -Fq "$start" "$ZSHRC"; then
    return
  fi

  tmp="$(mktemp)"
  awk -v s="$start" -v e="$end" '
    $0 == s { skip=1; next }
    $0 == e { skip=0; next }
    skip != 1 { print }
  ' "$ZSHRC" > "$tmp"
  mv "$tmp" "$ZSHRC"
}

remove_old_shortcut() {
  remove_block "$OLD_MARKER_START" "$OLD_MARKER_END"
}

remove_existing_reset_wifi_shortcut() {
  remove_block "$SHORTCUT_MARKER_START" "$SHORTCUT_MARKER_END"
}

add_reset_wifi_shortcut() {
  remove_existing_reset_wifi_shortcut

  cat <<'FUNC' >> "$ZSHRC"

# >>> reset-wifi shortcut >>>
reset() {
  if [[ "$1" == "wifi" ]]; then
    shift
    command reset-wifi "$@"
  else
    command reset "$@"
  fi
}
# <<< reset-wifi shortcut <<<
FUNC
}

mkdir -p "$BIN_DIR"
install -m 0755 "$ROOT_DIR/bin/reset-wifi" "$TARGET"
rm -f "$OLD_TARGET"

touch "$ZSHRC"
remove_old_shortcut
add_reset_wifi_shortcut

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *)
    cat <<SHELL >> "$ZSHRC"

# Added by reset-wifi
export PATH="\$HOME/.local/bin:\$PATH"
SHELL
    ;;
esac

cat <<DONE
Installed reset-wifi.

Restart your terminal or run:
  source "$ZSHRC"

Then run:
  reset wifi

Optional:
  reset wifi --delay 3
  reset wifi --quiet
  reset wifi --open-settings
  reset wifi --no-cycle
DONE
