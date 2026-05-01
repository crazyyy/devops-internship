#!/bin/bash

LOG_FILE="/var/log/disk_monitor.log"
THRESHOLD=1

USAGE=$(df -h / | awk 'NR==2 {gsub("%","",$5); print $5}')
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

if [ "$USAGE" -gt "$THRESHOLD" ]; then
  echo "[$TIMESTAMP] WARNING: Disk usage at ${USAGE}%" >> "$LOG_FILE"
fi
