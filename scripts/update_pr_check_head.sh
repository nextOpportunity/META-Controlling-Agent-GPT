#!/usr/bin/env bash
set -euo pipefail

FILE=".github/workflows/pr-check.yaml"
BACKUP="$FILE.bak.$(date +%Y%m%d_%H%M%S)"

[ -f "$FILE" ] || { echo "❌ $FILE nicht gefunden"; exit 1; }

LINE=$(awk '/^[[:space:]]*jobs:/{print NR; exit}' "$FILE")
if [ -z "${LINE:-}" ]; then
  echo "❌ 'jobs:' nicht gefunden – bitte Datei manuell prüfen."
  exit 2
fi

cp "$FILE" "$BACKUP"

TMP="$(mktemp)"
{
  cat <<'HEAD'
name: MCAG PR Check

on:
  pull_request:
    types: [opened, synchronize, reopened, ready_for_review]
    branches: ["**"]
  push:
    branches: ["main"]

permissions:
  contents: read
  pull-requests: write  # nötig zum Kommentieren

concurrency:
  group: mcag-${{ github.event.pull_request.number || github.sha }}
  cancel-in-progress: true

HEAD
  tail -n +"$LINE" "$FILE"
} > "$TMP"

mv "$TMP" "$FILE"
echo "✅ Header aktualisiert. Backup: $BACKUP"
