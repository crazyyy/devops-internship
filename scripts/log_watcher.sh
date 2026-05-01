#!/bin/bash

DISK_LOG="/var/log/disk_monitor.log"
RAM_LOG="/var/log/ram_monitor.log"
OUT_LOG="/var/log/email_notifications.log"

HOST=$(hostname)

TMP_FILE="/tmp/log_watcher.tmp"

touch "$TMP_FILE"

grep "WARNING" "$DISK_LOG" "$RAM_LOG" 2>/dev/null | while read line; do
    if ! grep -qF "$line" "$TMP_FILE"; then
        TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
        echo "[$TIMESTAMP] HOST: $HOST | $line" >> "$OUT_LOG"
        echo "$line" >> "$TMP_FILE"
    fi
done
