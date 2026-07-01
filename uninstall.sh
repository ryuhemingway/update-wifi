#!/usr/bin/env bash
set -euo pipefail

BIN="$HOME/.local/bin/reset-wifi"
OLD_BIN="$HOME/.local/bin/update-wifi"
ZSHRC="$HOME/.zshrc"
SHORTCUT_START="# >>> reset-wifi shortcut >>>"
SHORTCUT_END="# <<< reset-wifi shortcut <<<"
OLD_SHORTCUT_START="# >>> update-wifi shortcut >>>"
OLD_SHORTCUT_END="# <<< update-wifi shortcut <<<"

rm -f "$BIN"
rm -f "$OLD_BIN"

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

if [[ -f "$ZSHRC" ]]; then
  remove_block "$SHORTCUT_START" "$SHORTCUT_END"
  remove_block "$OLD_SHORTCUT_START" "$OLD_SHORTCUT_END"
fi

echo "Uninstalled reset-wifi."
