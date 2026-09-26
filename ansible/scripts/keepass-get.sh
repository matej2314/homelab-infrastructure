#!/usr/bin/env bash
# Odczyt jednego wpisu z KeePassXC (control node).
# Użycie: keepass-get.sh <group> <key>
# Ścieżka wpisu: homelab-infrastructure/<group>/<key>
# Baza: HOMELAB_KEEPASS_DB (ścieżka do projects.kdbx).
# Hasło główne: HOMELAB_KEEPASS_PASSWORD w środowisku procesu (wrapper run-playbook.sh).
# Sukces: pole Password na stdout, bez końcowego newline.
# Błąd: exit != 0 i komunikat na stderr. Hasło główne nie jest wypisywane.

set -euo pipefail

GROUP="${1:-}"
KEY="${2:-}"
REPO_GROUP="homelab-infrastructure"

if [[ -z "$GROUP" || -z "$KEY" ]]; then
  echo "usage: $0 <group> <key>" >&2
  exit 2
fi

if ! command -v keepassxc-cli >/dev/null 2>&1; then
  echo "keepassxc-cli not found (install keepassxc)" >&2
  exit 1
fi

DB="${HOMELAB_KEEPASS_DB:-}"
if [[ -z "$DB" || ! -f "$DB" ]]; then
  echo "HOMELAB_KEEPASS_DB is unset or not a file" >&2
  exit 1
fi

if [[ -z "${HOMELAB_KEEPASS_PASSWORD:-}" ]]; then
  echo "HOMELAB_KEEPASS_PASSWORD is unset (run playbooks via scripts/run-playbook.sh)" >&2
  exit 1
fi

ENTRY="${REPO_GROUP}/${GROUP}/${KEY}"
err_file="$(mktemp)"
trap 'rm -f "$err_file"' EXIT

if ! VALUE="$(
  printf '%s\n' "$HOMELAB_KEEPASS_PASSWORD" |
    env -u HOMELAB_KEEPASS_PASSWORD \
      keepassxc-cli show -q -s -a Password "$DB" "$ENTRY" 2>"$err_file"
)"; then
  echo "keepassxc-cli failed: group=${GROUP} key=${KEY}" >&2
  cat "$err_file" >&2
  exit 1
fi

if [[ -z "$VALUE" ]]; then
  echo "missing KeePassXC secret: group=${GROUP} key=${KEY}" >&2
  cat "$err_file" >&2
  exit 1
fi

printf '%s' "$VALUE"