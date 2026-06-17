#!/usr/bin/env bash
set -euo pipefail

BIN="$HOME/.local/bin/update-wifi"
ZSHRC="$HOME/.zshrc"

rm -f "$BIN"

if [[ -f "$ZSHRC" ]]; then
  tmp="$(mktemp)"
  awk '
    /^# >>> update-wifi shortcut >>>$/ { skip=1; next }
    /^# <<< update-wifi shortcut <<<$/ { skip=0; next }
    skip != 1 { print }
  ' "$ZSHRC" > "$tmp"
  mv "$tmp" "$ZSHRC"
fi

echo "Uninstalled update-wifi."
