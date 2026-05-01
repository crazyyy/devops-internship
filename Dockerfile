FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# install cron
RUN apt update && apt install -y cron

# create log directory
RUN mkdir -p /var/log

# copy scripts
COPY scripts/ /usr/local/bin/

# make scripts executable
RUN chmod +x /usr/local/bin/*.sh

# setup cron jobs
RUN (crontab -l 2>/dev/null; echo "0 * * * * /usr/local/bin/disk_monitor.sh") | crontab - && \
    (crontab -l 2>/dev/null; echo "0 * * * * /usr/local/bin/ram_monitor.sh") | crontab - && \
    (crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/log_watcher.sh") | crontab -

# default log file for cron
RUN touch /var/log/cron.log

# redirect cron output to log file
CMD cron -f
