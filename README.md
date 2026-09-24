# Personal Homelab

## English Version

### Overview

This repository documents a personal homelab built as a small, practical infrastructure environment for learning, experimentation and separating self-hosted services from the main development workstation.

It is a case study: hardware choices, assumptions, trade-offs and planned work live in this README. The same repo also holds **Ansible playbooks and Compose stacks** under `ansible/` so the server can be brought up repeatably on a lab VM (default) or, deliberately, on production.

### Motivation

The homelab was created to support several goals:

- Learn DevOps and infrastructure-related practices in a real environment.
- Move Docker-based applications away from the main workstation.
- Reduce the workload and background services running on the development machine.
- Create local storage for projects and related resources.
- Learn Linux server setup and hardening from the ground up.
- Practice Infrastructure as Code (Ansible + Compose) without treating the production Dell as a test target.

Instead of treating infrastructure as something abstract or cloud-only, this setup provides a controlled local environment where services can be installed, configured, monitored and improved incrementally.

### Hardware

The homelab runs on a refurbished Dell mini PC.

| Component | Specification |
| --- | --- |
| CPU | Intel Core i5-9500T |
| RAM | 16 GB DDR4 |
| Storage | 512 GB NVMe SSD (system); 4 TB SATA SSD (data storage, mounted at `/mnt/HomelabData`) |
| Form factor | Dell mini PC |
| Type | Refurbished business-class machine |

The hardware was selected because it offered a good balance between price, performance and power efficiency. A small refurbished machine was enough for the initial scope while keeping the setup affordable and quiet.

### Operating System

The server runs Ubuntu Server 26.04.

The system was installed and configured from scratch, which made the setup process part of the learning experience. At this stage, not every part of the server is fully hardened, but the foundation is in place and can be improved over time. Day-to-day deployment of stacks is driven from Ansible on a Kubuntu control node.

### Current Scope

Single-node LAN-only server. What exists in this repository today:

**Host / system (Ansible `bootstrap.yml`, `system-services.yml`)**

- Docker Engine, Compose plugin, external Docker network `main_network`
- Prometheus (listen port `6705`) and node_exporter
- Grafana from the [official Grafana Labs APT repo](https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/), admin credentials from KWallet, Prometheus datasource + provisioned dashboard JSON
- Operator tools: `btop`, `lazydocker`

**Compose stacks under `ansible/files/compose/` (wired into playbooks / `site.yml`)**

| Area | Playbook | Stacks |
| --- | --- | --- |
| Proxy | `apps-proxy.yml` | Nginx Proxy Manager (`80`/`443`/`81`) — proxy hosts and DuckDNS/TLS are configured in the NPM UI, not by Ansible |
| Secrets app | `apps-vault.yml` | HashiCorp Vault (container; init/unseal is manual) |
| Data | `apps-data.yml` | MySQL + phpMyAdmin; Postgres (pgvector) + pgAdmin |
| AI | `apps-ai.yml` | Ollama + embedding model pull |
| CI | `apps-cicd.yml` | Jenkins (local Dockerfile; Docker socket GID from the host) |
| Tools | `apps-tools.yml` | cAdvisor (`6700`), it-tools, omni-tools, Stirling PDF (`7070`), Trilium Notes (`7080`), FileBrowser Quantum, Homarr (`7575`), Redis Stack (`6379`), Kopia backup UI (`51515`) |

Secrets used by Compose and Grafana are read from **KDE Wallet** on the control node (see `ansible/files/compose/kwallet-keys.md`). Values are never committed; Ansible may write short-lived `.env` files on the server with mode `0600`.

Also in scope operationally (not fully automated here): Wake-on-LAN; local storage under `/mnt/HomelabData` on the Dell.

### Architecture Assumptions

The homelab is a single-node local server. Services stay on the LAN; public exposure is not part of the current design. VPN for remote access is planned later.

Compose files are treated as **production-shaped** copies (paths such as `/mnt/HomelabData/...`). On the **lab** inventory, Ansible creates those paths as ordinary directories on one disk (`ensure-lab-host-paths.yml`) so bind mounts work without a second physical drive. On **prod**, those paths are assumed to already exist (real data disk mount).

### Key Decisions

- Docker + one external network `main_network` for application stacks.
- Ansible layered playbooks; default inventory is lab, never prod by accident.
- Secrets from KWallet on Kubuntu; HashiCorp Vault is an app on the server, not the Ansible secret backend.
- Monitoring early (Prometheus, Grafana, cAdvisor).
- NPM as the intended HTTP(S) front; certificate and proxy rules stay manual in the UI.

### Trade-Offs

- Single point of failure; no HA; limited budget.
- Backup **policy** (schedules, restore tests, retention) is not finished — only the Kopia stack is automated.
- Full green-field validation of `site.yml` on a clean lab VM is ongoing learning work, not a claimed production guarantee.
- Some hardening and VPN work remain future goals.

### Security Model

- LAN-only services; no intentional public exposure of the server.
- SSH key authentication (password login disabled on the server).
- No secret values in git; KWallet folders `Homelab-lab` / `Homelab-prod`.
- VPN and further hardening are planned improvements.

### Backup Status

A complete backup strategy has not been designed yet.

The [Kopia](https://kopia.io/) stack is in `ansible/files/compose/backup-system/`, deployed by `apps-tools.yml` (and `site.yml`). UI on port `51515`; repository path `/mnt/HomelabData/homelab-backup`; secrets via KWallet (`KOPIA_*` keys in `kwallet-keys.md`). On lab, Ansible creates the path directories; on prod they come from the real data disk. Deploying the container is not the same as a finished backup policy.

### Lessons Learned

Initial OS and hardware setup was smoother than expected. The project already provided practice with Ubuntu Server from scratch; Ansible is now the main way to make the stack repeatable for learning on a VM before touching production.

### Planned Improvements

- Backup policy (schedules, restore tests, retention).
- VPN-based remote access.
- Further Linux hardening.
- NPM/DuckDNS host wiring as a documented manual runbook (or later automation).
- More services only when there is a clear need.
- Keep README and `ansible/` aligned as the setup evolves.

### Repository Scope

This repository contains:

1. **This README** — case study, assumptions, trade-offs.
2. **`ansible/`** — inventories (lab/prod), layered playbooks, shared tasks, Compose/Dockerfile assets, KWallet key map, Grafana/Prometheus configs.

It is a personal learning IaC setup for this homelab, not a generic public template or a claim of production-hardened automation.

### Ansible (lab vs prod)

Always work from the `ansible/` directory. Install collections first: `ansible-galaxy collection install -r requirements.yml`.

- Lab (default in `ansible.cfg`): `ansible-playbook playbooks/<playbook>.yml`
- Prod (intentional only): `ansible-playbook -i inventory/prod.yml playbooks/<playbook>.yml`
- Prefer one layer at a time; full stack: `ansible-playbook playbooks/site.yml` only after each layer works alone
- Layers: `ping` → `kwallet-smoke` → `bootstrap` → `system-services` → `apps-proxy` → `apps-vault` → `apps-data` → `apps-ai` → `apps-cicd` → `apps-tools`
- Required KWallet key names: `ansible/files/compose/kwallet-keys.md`

The production Dell is not a test target. Fill inventory placeholders (`__LAB_HOST__`, and so on) locally before running playbooks.

---

## Wersja Polska

### Opis

To repozytorium dokumentuje osobisty homelab — małe środowisko do nauki, eksperymentów i oddzielenia usług self-hosted od stacji deweloperskiej.

Jest to case study (sprzęt, założenia, kompromisy, plany) w tym README oraz **automatyzacja Ansible + Compose** w katalogu `ansible/`, żeby powtarzalnie stawiać usługi na VM-lab (domyślnie) albo świadomie na produkcji.

### Motywacja

- Nauka DevOps i infrastruktury w realnym środowisku.
- Przeniesienie aplikacji dockerowych poza główną stację.
- Odciążenie komputera do codziennej pracy.
- Lokalny storage na projekty.
- Nauka Linuxa i hardeningu od podstaw.
- Ćwiczenie IaC (Ansible + Compose) bez używania produkcyjnego Della jako poligonu.

### Sprzęt

Homelab działa na poleasingowym mini PC Dell.

| Komponent | Specyfikacja |
| --- | --- |
| CPU | Intel Core i5-9500T |
| RAM | 16 GB DDR4 |
| Dysk | 512 GB NVMe SSD (system); 4 TB SATA SSD (dane, montowane jako `/mnt/HomelabData`) |
| Format | Dell mini PC |
| Typ | Poleasingowy komputer biznesowy |

### System Operacyjny

Ubuntu Server 26.04, instalacja od zera. Deployment stacków na co dzień idzie z laptopa (Kubuntu) przez Ansible.

### Obecny Zakres

Serwer single-node, tylko LAN. To, co jest w repo:

**Host / system (`bootstrap.yml`, `system-services.yml`)**

- Docker Engine, Compose, sieć `main_network`
- Prometheus (port `6705`), node_exporter
- Grafana z [oficjalnego APT Grafana Labs](https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/), admin z KWallet, datasource Prometheus + dashboard z JSON
- `btop`, `lazydocker`

**Stacki Compose (`ansible/files/compose/` → playbooki / `site.yml`)**

| Obszar | Playbook | Stacki |
| --- | --- | --- |
| Proxy | `apps-proxy.yml` | Nginx Proxy Manager (`80`/`443`/`81`) — hosty i DuckDNS/TLS w GUI NPM, nie w Ansible |
| Sejf aplikacji | `apps-vault.yml` | HashiCorp Vault (kontener; init/unseal ręcznie) |
| Dane | `apps-data.yml` | MySQL + phpMyAdmin; Postgres (pgvector) + pgAdmin |
| AI | `apps-ai.yml` | Ollama + model embeddingowy |
| CI | `apps-cicd.yml` | Jenkins (lokalny Dockerfile; GID Dockera z hosta) |
| Narzędzia | `apps-tools.yml` | cAdvisor (`6700`), it-tools, omni-tools, Stirling PDF (`7070`), Trilium (`7080`), FileBrowser, Homarr (`7575`), Redis Stack (`6379`), Kopia (`51515`) |

Sekrety: **KDE Wallet** na control node (`ansible/files/compose/kwallet-keys.md`), bez wartości w gicie. Ansible może zapisać `.env` na serwerze z uprawnieniami `0600`.

Poza pełną automatyzacją w repo: Wake-on-LAN; storage pod `/mnt/HomelabData` na Dellu.

### Założenia Architektury

Jeden serwer w LAN, bez wystawiania do internetu; VPN później.

Pliki Compose są **produkcyjne** (ścieżki jak `/mnt/HomelabData/...`). Na **lab** Ansible tworzy te ścieżki jako zwykłe katalogi na jednym dysku (`ensure-lab-host-paths.yml`). Na **prod** zakłada się, że już istnieją (prawdziwy montaż dysku danych).

### Kluczowe Decyzje

- Docker + wspólna sieć `main_network`.
- Warstwowe playbooki Ansible; domyślny inventory = lab.
- Sekrety z KWallet; Vault HashiCorp to usługa na serwerze, nie backend Ansible.
- Wczesny monitoring (Prometheus, Grafana, cAdvisor).
- NPM jako front HTTP(S); certyfikaty i reguły proxy ręcznie w UI.

### Kompromisy

- Single point of failure, brak HA, ograniczony budżet.
- Polityka backupu (harmonogramy, restore, retencja) jeszcze niegotowa — zautomatyzowany jest stack Kopii.
- Pełna walidacja `site.yml` na czystej VM to praca w toku, nie gwarancja produkcyjna.
- Hardening i VPN — do zrobienia później.

### Model Bezpieczeństwa

- Usługi tylko w LAN.
- SSH na kluczu (bez logowania hasłem na serwerze).
- Brak sekretów w gicie; foldery KWallet `Homelab-lab` / `Homelab-prod`.
- VPN i dalszy hardening w planach.

### Status Backupu

Kompletna strategia backupu nie jest jeszcze zaprojektowana.

Stack [Kopia](https://kopia.io/): `ansible/files/compose/backup-system/`, playbook `apps-tools.yml` (i `site.yml`). UI `51515`, repozytorium `/mnt/HomelabData/homelab-backup`, sekrety KWallet (`KOPIA_*` w `kwallet-keys.md`). Na lab katalogi tworzy Ansible; na prod pochodzą z dysku danych. Sam kontener ≠ gotowa polityka backupu.

### Wnioski

Początkowa instalacja OS/sprzętu poszła gładko. Ansible ma uczynić stack powtarzalnym na VM przed ruszaniem produkcji.

### Planowane Usprawnienia

- Polityka backupu.
- VPN.
- Hardening.
- Runbook NPM/DuckDNS (później ewentualna automatyzacja).
- Kolejne usługi tylko przy jasnej potrzebie.
- Spójność README i `ansible/` przy dalszych zmianach.

### Zakres Repozytorium

1. **Ten README** — case study i założenia.
2. **`ansible/`** — inventory lab/prod, warstwowe playbooki, taski, Compose/Dockerfile, mapa kluczy KWallet, konfiguracja Prometheus/Grafana.

To osobisty setup IaC do nauki przy tym homelabie — nie uniwersalny szablon ani obietnica „production-ready”.

### Ansible (lab vs prod)

Praca zawsze z katalogu `ansible/`. Najpierw: `ansible-galaxy collection install -r requirements.yml`.

- Lab (domyślne w `ansible.cfg`): `ansible-playbook playbooks/<playbook>.yml`
- Prod (tylko świadomie): `ansible-playbook -i inventory/prod.yml playbooks/<playbook>.yml`
- Najpierw warstwy osobno; `site.yml` dopiero gdy każda przechodzi sama
- Warstwy: `ping` → `kwallet-smoke` → `bootstrap` → `system-services` → `apps-proxy` → `apps-vault` → `apps-data` → `apps-ai` → `apps-cicd` → `apps-tools`
- Nazwy kluczy KWallet: `ansible/files/compose/kwallet-keys.md`

Dell produkcyjny nie jest celem testów. Placeholdery w inventory (`__LAB_HOST__` itd.) uzupełnij lokalnie przed uruchomieniem.
