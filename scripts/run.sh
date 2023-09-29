#! /bin/bash
touch /var/log/cron.log
env | egrep '^BACKUP' | cat - /tmp/backup-cronjob > /etc/cron.d/backup-cronjob
crontab /etc/cron.d/backup-cronjob

_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

cron -f &

child=$! 
wait "$child"