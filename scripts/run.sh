#! /bin/bash

if [ "$USE_CRON" = false ] ; then
    echo "Not using Cron, running backup script directly"
    /root/backup.sh
    exit
fi

touch /var/log/cron.log
env | egrep '^BACKUP' | cat > /etc/cron.d/backup-cronjob
echo "$BACKUP_FREQUENCY /root/backup.sh" >> /etc/cron.d/backup-cronjob
crontab /etc/cron.d/backup-cronjob

_term() { 
    echo "Caught SIGTERM signal!" 
    kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

cron -f &

child=$! 
wait "$child"