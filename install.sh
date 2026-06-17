#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
TARGET="$BIN_DIR/update-wifi"
ZSHRC="$HOME/.zshrc"
MARKER_START="# >>> update-wifi shortcut >>>"
MARKER_END="# <<< update-wifi shortcut <<<"

mkdir -p "$BIN_DIR"
install -m 0755 "$ROOT_DIR/bin/update-wifi" "$TARGET"

touch "$ZSHRC"

if ! grep -Fq "$MARKER_START" "$ZSHRC"; then
  cat >> "$ZSHRC" <<'SHELL'

# >>> update-wifi shortcut >>>
update() {
  if [[ "${1:-}" == "wifi" ]]; then
    shift
    command update-wifi "$@"
  else
    echo "Usage: update wifi [--no-cycle]"
    return 2
  fi
}
# <<< update-wifi shortcut <<<
SHELL
fi

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *)
    cat <<SHELL >> "$ZSHRC"

# Added by update-wifi
export PATH="\$HOME/.local/bin:\$PATH"
SHELL
    ;;
esac

cat <<DONE
Installed update-wifi.

Restart your terminal or run:
  source "$ZSHRC"

Then run:
  update wifi

Optional:
  update wifi --no-cycle
DONE
