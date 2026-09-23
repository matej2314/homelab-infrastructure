#!/usr/bin/env bash
# Odczyt jednego wpisu z KDE Wallet (control node).
# Użycie: kwallet-get.sh <folder> <key>
# Sukces: wartość na stdout (bez dodatkowego newline-control — printf).
# Błąd: exit != 0 i komunikat na stderr.

set -euo pipefail

FOLDER="${1:-}"
KEY="${2:-}"

if [[ -z "$FOLDER" || -z "$KEY" ]]; then
  echo "usage: $0 <kwallet_folder> <key>" >&2
  exit 2
fi

if ! command -v secret-tool >/dev/null 2>&1; then
  echo "secret-tool not found (install libsecret-tools)" >&2
  exit 1
fi

VALUE="$(secret-tool lookup homelab-folder "$FOLDER" homelab-key "$KEY" || true)"
if [[ -z "${VALUE}" ]]; then
  echo "missing KWallet secret: folder=${FOLDER} key=${KEY}" >&2
  exit 1
fi

printf '%s' "$VALUE"
