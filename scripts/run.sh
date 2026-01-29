#! /bin/ash

if [ "$USE_CRON" = false ] ; then
    echo "Not using Cron, running backup script directly"
    /tmp/backup.sh
    exit
fi

touch /var/log/cron.log
env > /etc/crontabs/backup-cronjob
echo "$BACKUP_FREQUENCY /tmp/backup.sh" >> /etc/crontabs/backup-cronjob
crontab /etc/crontabs/backup-cronjob

_term() { 
    echo "Caught SIGTERM signal!" 
    kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

crond -f &

child=$! 
wait "$child"