# Personal Homelab

## English Version

### Overview

This repository documents a personal homelab built as a small, practical infrastructure environment for learning, experimentation and separating self-hosted services from the main development workstation.

The project is intentionally described as a case study rather than a ready-to-run infrastructure template. Its main purpose is to document the hardware choice, technical assumptions, early decisions, current state, trade-offs and planned improvements behind the setup.

### Motivation

The homelab was created to support several goals:

- Learn DevOps and infrastructure-related practices in a real environment.
- Move Docker-based applications away from the main workstation.
- Reduce the workload and background services running on the development machine.
- Create local storage for projects and related resources.
- Learn Linux server setup and hardening from the ground up.

Instead of treating infrastructure as something abstract or cloud-only, this setup provides a controlled local environment where services can be installed, configured, monitored and improved incrementally.

### Hardware

The homelab runs on a refurbished Dell mini PC.

| Component | Specification |
| --- | --- |
| CPU | Intel Core i5-9500T |
| RAM | 16 GB DDR4 |
| Storage | 512 GB NVMe SSD |
| Form factor | Dell mini PC |
| Type | Refurbished business-class machine |

The hardware was selected because it offered a good balance between price, performance and power efficiency. A small refurbished machine was enough for the initial scope while keeping the setup affordable and quiet.

### Operating System

The server runs Ubuntu Server 26.04.

The system was installed and configured from scratch, which made the setup process part of the learning experience. At this stage, not every part of the server is fully hardened or automated yet, but the foundation is in place and can be improved over time.

### Current Scope

The current scope focuses on a small local infrastructure environment:

- Docker for running containerized services.
- Prometheus for metrics collection.
- Grafana for visualization and dashboards.
- Local storage shared between containers and selected system services.
- Wake-on-LAN support for powering on the machine remotely inside the local network.

The setup may be extended with additional services in the future, depending on actual needs.

### Architecture Assumptions

The homelab is currently designed as a single-node local server.

The main architectural assumption is to keep services inside the local network and use the server as a dedicated place for infrastructure-related workloads. Storage is intended to serve both containerized applications and selected system-level services.

At this stage, the server is not exposed to the public internet. Services are available only inside the local LAN. A VPN access path is planned for the future to provide controlled remote connectivity without exposing services directly.

### Key Decisions

The initial implementation is based on a few practical decisions:

- Use Docker as the primary way to run application services.
- Keep the server local-only instead of exposing it to the internet.
- Enable Wake-on-LAN to make the machine easier to manage.
- Start with a simple single-host architecture before adding more complexity.
- Treat monitoring as an early part of the setup through Prometheus and Grafana.

These choices keep the environment understandable and manageable while still leaving room for future improvements.

### Trade-Offs

The current setup accepts several trade-offs:

- The server is a single point of failure.
- The budget is intentionally limited.
- There is no high availability layer.
- Backup strategy has not been fully designed yet.
- Some hardening and automation work is still planned rather than completed.

For the current purpose of learning and local experimentation, these trade-offs are acceptable. They also make the project easier to evolve step by step.

### Security Model

The current security approach is conservative:

- Services are available only inside the local LAN.
- The server is not exposed directly to the public internet.
- SSH password authentication is disabled; key-based authentication is required.
- Remote access through VPN is planned as a future improvement.
- Linux hardening is one of the learning goals of the project.

The security model is expected to evolve as the homelab becomes more mature.

### Backup Status

At the moment, a complete backup strategy has not been designed yet.

This is an intentional area for future work. A production-like homelab should eventually include regular backups, restore testing and a clear distinction between configuration backups, application data backups and project storage backups.

### Lessons Learned

One of the most surprising parts of the process was how straightforward the initial setup was. Even though the hardware is not new, the installation and first configuration steps went smoothly.

The project has already provided practical experience with installing and configuring Ubuntu Server from scratch. Some areas still require additional work, but the base system is operational and ready for further iteration.

### Planned Improvements

Future improvements may include:

- Designing and implementing a proper backup strategy.
- Adding VPN-based remote access.
- Extending Linux hardening.
- Expanding monitoring dashboards.
- Adding more self-hosted services when there is a clear need.
- Documenting architecture changes as the setup evolves.

### Repository Scope

This repository currently focuses on documentation. It does not aim to provide a complete infrastructure-as-code setup, deployment automation or production-ready configuration files.

The main artifact is this README, which describes the reasoning and current state of the homelab.

---

## Wersja Polska

### Opis

To repozytorium dokumentuje osobisty homelab zbudowany jako małe, praktyczne środowisko infrastrukturalne do nauki, eksperymentowania i oddzielenia usług self-hosted od głównej stacji roboczej używanej do pracy deweloperskiej.

Projekt jest celowo opisany jako case study, a nie jako gotowy szablon infrastruktury do uruchomienia. Jego głównym celem jest udokumentowanie wyboru sprzętu, założeń technicznych, pierwszych decyzji, obecnego stanu, kompromisów oraz planowanych usprawnień.

### Motywacja

Homelab powstał z kilku powodów:

- Nauka praktyk związanych z DevOps i infrastrukturą.
- Przeniesienie aplikacji dockerowych poza główną stację roboczą.
- Odciążenie komputera używanego do codziennej pracy deweloperskiej.
- Stworzenie lokalnego storage'u dla projektów i powiązanych zasobów.
- Nauka konfiguracji i hardeningu serwera Linux od podstaw.

Zamiast traktować infrastrukturę jako coś abstrakcyjnego albo dostępnego wyłącznie w chmurze, ten homelab daje kontrolowane lokalne środowisko, w którym można instalować, konfigurować, monitorować i rozwijać usługi krok po kroku.

### Sprzęt

Homelab działa na poleasingowym mini PC firmy Dell.

| Komponent | Specyfikacja |
| --- | --- |
| CPU | Intel Core i5-9500T |
| RAM | 16 GB DDR4 |
| Dysk | 512 GB NVMe SSD |
| Format | Dell mini PC |
| Typ | Poleasingowy komputer biznesowy |

Sprzęt został wybrany ze względu na dobry stosunek ceny do wydajności oraz energooszczędność. Mały komputer poleasingowy okazał się wystarczający dla początkowego zakresu projektu, przy zachowaniu rozsądnego kosztu i niewielkiego poboru energii.

### System Operacyjny

Serwer działa na Ubuntu Server 26.04.

System został zainstalowany i skonfigurowany od zera, dzięki czemu sam proces konfiguracji stał się częścią nauki. Na tym etapie nie każdy element serwera jest jeszcze w pełni utwardzony lub zautomatyzowany, ale podstawy są gotowe i mogą być rozwijane iteracyjnie.

### Obecny Zakres

Obecny zakres skupia się na małym lokalnym środowisku infrastrukturalnym:

- Docker do uruchamiania usług kontenerowych.
- Prometheus do zbierania metryk.
- Grafana do wizualizacji i dashboardów.
- Lokalny storage współdzielony przez kontenery i wybrane usługi systemowe.
- Wake-on-LAN do zdalnego uruchamiania maszyny w ramach sieci lokalnej.

Konfiguracja może zostać rozbudowana o kolejne usługi w przyszłości, zależnie od faktycznych potrzeb.

### Założenia Architektury

Homelab jest obecnie projektowany jako pojedynczy lokalny serwer.

Główne założenie architektoniczne polega na utrzymaniu usług wewnątrz sieci lokalnej i wykorzystaniu serwera jako dedykowanego miejsca dla zadań infrastrukturalnych. Storage ma obsługiwać zarówno aplikacje kontenerowe, jak i wybrane usługi systemowe.

Na tym etapie serwer nie jest wystawiony do publicznego internetu. Usługi są dostępne wyłącznie w ramach lokalnej sieci LAN. W przyszłości planowane jest dodanie dostępu przez VPN, aby zapewnić kontrolowany zdalny kanał komunikacji bez bezpośredniego wystawiania usług.

### Kluczowe Decyzje

Pierwsza wersja homelaba opiera się na kilku praktycznych decyzjach:

- Wykorzystanie Dockera jako głównego sposobu uruchamiania usług aplikacyjnych.
- Utrzymanie serwera wyłącznie w sieci lokalnej zamiast wystawiania go do internetu.
- Aktywacja Wake-on-LAN, aby ułatwić zarządzanie maszyną.
- Start od prostej architektury single-host przed dodawaniem większej złożoności.
- Uwzględnienie monitoringu już na wczesnym etapie przez Prometheusa i Grafanę.

Takie decyzje utrzymują środowisko w zrozumiałej i łatwej do zarządzania formie, jednocześnie zostawiając miejsce na dalszy rozwój.

### Kompromisy

Obecna konfiguracja akceptuje kilka kompromisów:

- Serwer jest pojedynczym punktem awarii.
- Budżet jest celowo ograniczony.
- Nie ma warstwy wysokiej dostępności.
- Strategia backupów nie została jeszcze w pełni zaprojektowana.
- Część prac związanych z hardeningiem i automatyzacją jest nadal w planach.

Na potrzeby nauki i lokalnego eksperymentowania te kompromisy są akceptowalne. Ułatwiają też rozwijanie projektu krok po kroku.

### Model Bezpieczeństwa

Obecne podejście do bezpieczeństwa jest konserwatywne:

- Usługi są dostępne tylko w lokalnej sieci LAN.
- Serwer nie jest wystawiony bezpośrednio do publicznego internetu.
- Logowanie SSH hasłem jest wyłączone; wymagane jest uwierzytelnianie kluczem.
- Zdalny dostęp przez VPN jest planowany jako przyszłe usprawnienie.
- Hardening Linuxa jest jednym z celów nauki w ramach projektu.

Model bezpieczeństwa będzie rozwijany wraz z dojrzewaniem homelaba.

### Status Backupu

Na ten moment kompletna strategia backupu nie została jeszcze zaprojektowana.

To świadomy obszar do dalszej pracy. Homelab zbliżony do środowiska produkcyjnego powinien docelowo obejmować regularne backupy, testy odtwarzania oraz jasny podział między backupami konfiguracji, danych aplikacyjnych i storage'u projektowego.

### Wnioski

Jednym z największych zaskoczeń była prostota początkowej konfiguracji. Mimo że sprzęt ma już swoje lata, instalacja oraz pierwsze kroki konfiguracyjne przebiegły bez większych przeszkód.

Projekt pozwolił już zdobyć praktyczne doświadczenie w instalacji i konfiguracji Ubuntu Server od zera. Część obszarów nadal wymaga dalszej pracy, ale bazowy system działa i jest gotowy na kolejne iteracje.

### Planowane Usprawnienia

Możliwe dalsze usprawnienia obejmują:

- Zaprojektowanie i wdrożenie poprawnej strategii backupu.
- Dodanie zdalnego dostępu przez VPN.
- Rozszerzenie hardeningu Linuxa.
- Rozbudowę dashboardów monitoringowych.
- Dodawanie kolejnych usług self-hosted, gdy pojawi się konkretna potrzeba.
- Dokumentowanie zmian architektury wraz z rozwojem środowiska.

### Zakres Repozytorium

To repozytorium skupia się obecnie na dokumentacji. Nie ma na celu dostarczenia kompletnego podejścia infrastructure-as-code, automatyzacji deploymentu ani produkcyjnych plików konfiguracyjnych.

Głównym artefaktem jest ten README, który opisuje uzasadnienie oraz obecny stan homelaba.
