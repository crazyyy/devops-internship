#!/bin/bash

LOG_FILE="/var/log/ram_monitor.log"
THRESHOLD=1

read USED TOTAL <<< $(free -m | awk '/Mem:/ {print $3, $2}')
USAGE=$(( USED * 100 / TOTAL ))

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

if [ "$USAGE" -gt "$THRESHOLD" ]; then
  echo "[$TIMESTAMP] WARNING: RAM usage at ${USAGE}% (${USED}M/${TOTAL}M used)" >> "$LOG_FILE"
fi
