#! /bin/bash
touch /var/log/cron.log
env | egrep '^BACKUP' | cat - /tmp/backup-cronjob > /etc/cron.d/backup-cronjob
crontab /etc/cron.d/backup-cronjob
cron -f