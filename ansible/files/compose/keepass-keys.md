# Mapa kluczy KeePassXC (bez wartości)

Baza: `projects`.
Grupa repozytorium: `homelab-infrastructure`
Podgrupa lab: `lab` (inventory `keepass_group`)
Podgrupa prod: `prod`

Tytuł wpisu = nazwa klucza.
Wartość = pole Password.
Ścieżka CLI = `homelab-infrastructure/<lab|prod>/<klucz>`.

| Klucz | Stack / użycie |
|---|---|
| `MYSQL_ROOT_PASSWORD` | mysql-phpmyadmin — hasło root MySQL |
| `POSTGRESDB_USERNAME` | postgres-pgvector — użytkownik Postgres |
| `POSTGRESDB_PASSWORD` | postgres-pgvector — hasło superusera Postgres |
| `POSTGRESDB_DATABASE` | postgres-pgvector — nazwa bazy |
| `PGADMIN_DEFAULT_EMAIL` | postgres-pgvector — email logowania pgAdmin |
| `PGADMIN_DEFAULT_PASSWORD` | postgres-pgvector — hasło pgAdmin |
| `DASHBOARD_SECRET_ENCRYPTION_KEY` | dashboard (playbook `apps-tools.yml`) — klucz szyfrowania Homarr (`SECRET_ENCRYPTION_KEY` w kontenerze) |
| `KOPIA_BACKUP_PASSWORD` | backup-system (playbook `apps-tools.yml`) — hasło repozytorium Kopia (`KOPIA_PASSWORD` w kontenerze) |
| `KOPIA_SERVER_USERNAME` | backup-system (playbook `apps-tools.yml`) — użytkownik UI/serwera Kopia (`--server-username`) |
| `KOPIA_SERVER_PASSWORD` | backup-system (playbook `apps-tools.yml`) — hasło UI/serwera Kopia (`--server-password`) |
| `REDIS_PASSWORD` | redis (playbook `apps-tools.yml`) — hasło Redis (`requirepass` w `REDIS_ARGS`) |
| `FILEBROWSER_ADMIN_PASSWORD` | filebrowser-quantum — hasło admina FileBrowser |
| `GRAFANA_ADMIN_USER` | system Grafana (`system-services.yml`) — login admina (`GF_SECURITY_ADMIN_USER`) |
| `GRAFANA_ADMIN_PASSWORD` | system Grafana (`system-services.yml`) — hasło admina (`GF_SECURITY_ADMIN_PASSWORD`); działa przy pierwszym utworzeniu użytkownika |
| `GRAFANA_SERVER_PORT` | system Grafana (`system-services.yml`) — port HTTP interfejsu (`GF_SERVER_HTTP_PORT`); domyślnie `6701` |
| `ansible_lab_test` | `keepass-smoke.yml` — sekret testowy ścieżki KeePassXC → plik na serwerze |
| `vault_root_token` | `apps-vault.yml` — token roota HashiCorp Vault; przechowywany ręcznie, playbook go nie odczytuje |
