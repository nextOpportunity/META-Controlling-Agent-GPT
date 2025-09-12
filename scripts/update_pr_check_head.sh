#!/usr/bin/env bash
set -euo pipefail

FILE=".github/workflows/pr-check.yaml"
BACKUP="$FILE.bak.$(date +%Y%m%d_%H%M%S)"

# Sanity checks
[ -f "$FILE" ] || { echo "❌ $FILE nicht gefunden"; exit 1; }

# Zeile von 'jobs:' finden (mit optionalem Whitespace)
LINE=$(awk '/^[[:space:]]*jobs:/{print NR; exit}' "$FILE")
if [ -z "${LINE:-}" ]; then
  echo "❌ 'jobs:' nicht gefunden – bitte Datei manuell prüfen."
  exit 2
fi

# Backup anlegen
cp "$FILE" "$BACKUP"

# Neuen Kopf + Rest zusammenbauen
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

concurrency:
  group: mcag-${{ github.event.pull_request.number || github.sha }}
  cancel-in-progress: true

HEAD
  # Rest ab 'jobs:' beibehalten
  tail -n +"$LINE" "$FILE"
} > "$TMP"

mv "$TMP" "$FILE"
echo "✅ Header aktualisiert. Backup: $BACKUP"
