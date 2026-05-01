# Docker Monitoring (Disk + RAM + Log Watcher)

## Overview

This project runs system monitoring scripts inside a single Docker container:

- Disk usage monitor
- RAM usage monitor
- Log watcher (detects warnings)

All scripts are scheduled using **cron** (no systemd inside container).

Logs are stored in a **Docker named volume** and persist between restarts.

---

## Requirements

- Docker
- Docker Compose

---

## Build and Run

### 1. Build and start container

```bash
docker compose up -d --build
````

---

### 2. Check container is running

```bash
docker ps
```

Expected:

```sh
monitoring   Up ...
```

---

## Verify Cron Jobs

Enter container:

```bash
docker exec -it monitoring bash
```

Check cron jobs:

```bash
crontab -l
```

Expected output:

```sh
0 * * * * /usr/local/bin/disk_monitor.sh
0 * * * * /usr/local/bin/ram_monitor.sh
*/5 * * * * /usr/local/bin/log_watcher.sh
```

---

## Verify Logs Inside Container

```bash
ls /var/log
```

Expected files:

- disk_monitor.log
- ram_monitor.log
- email_notifications.log

View logs:

```bash
cat /var/log/disk_monitor.log
cat /var/log/ram_monitor.log
cat /var/log/email_notifications.log
```

---

## Verify Logs from Host (Docker Volume)

### 1. List volumes

```bash
docker volume ls
```

Find volume name (example):

```bash
devops-internship_monitoring_logs
```

---

### 2. Inspect volume

```bash
docker volume inspect devops-internship_monitoring_logs
```

---

### 3. Access logs via temporary container

```bash
docker run --rm -it -v devops-internship_monitoring_logs:/logs ubuntu bash
```

Inside container:

```bash
ls /logs
cat /logs/disk_monitor.log
```

---

## Manual Test (Recommended)

Run scripts manually:

```bash
docker exec -it monitoring bash

/usr/local/bin/disk_monitor.sh
/usr/local/bin/ram_monitor.sh
/usr/local/bin/log_watcher.sh
```

---

## Fast Testing Mode

To test quickly without waiting 1 hour:

Edit cron schedule in Dockerfile:

```bash
*/1 * * * * /usr/local/bin/disk_monitor.sh
*/1 * * * * /usr/local/bin/ram_monitor.sh
```

Rebuild:

```bash
docker compose down
docker compose up -d --build
```

---

## Restart Behavior

Container uses:

```bash
restart: unless-stopped
```

This means:

- container restarts automatically after reboot
- stops only if manually stopped
