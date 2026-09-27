#!/usr/bin/env bash
# Uruchamia ansible-playbook z hasłem głównym KeePassXC tylko w pamięci tego procesu.
# Użycie (katalog ansible/ albo dowolny cwd — skrypt sam przechodzi do ansible/):
#   export HOMELAB_KEEPASS_DB=/ścieżka/do/projects.kdbx
#   ./scripts/run-playbook.sh playbooks/<playbook>.yml
#   ./scripts/run-playbook.sh -i inventory/prod.yml playbooks/<playbook>.yml
# Hasło nie jest zapisywane do pliku. Każde uruchomienie pyta od nowa.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ -z "${HOMELAB_KEEPASS_DB:-}" || ! -f "${HOMELAB_KEEPASS_DB}" ]]; then
  echo "HOMELAB_KEEPASS_DB is unset or not a file (path to projects.kdbx)" >&2
  exit 1
fi

if [[ ! -t 0 ]]; then
  echo "run-playbook.sh requires a terminal to read the KeePassXC master password" >&2
  exit 1
fi

read -r -s -p "Hasło główne KeePassXC: " HOMELAB_KEEPASS_PASSWORD
echo >&2

if [[ -z "$HOMELAB_KEEPASS_PASSWORD" ]]; then
  echo "empty KeePassXC master password" >&2
  exit 1
fi

export HOMELAB_KEEPASS_DB HOMELAB_KEEPASS_PASSWORD
exec ansible-playbook "$@"