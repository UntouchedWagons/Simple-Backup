#! /bin/bash

BACKUP_DIRECTORY="/backups"

if [ -n $BACKUP_APPEND_DIRECTORY ]; then
    BACKUP_DIRECTORY=${BACKUP_DIRECTORY}${BACKUP_APPEND_DIRECTORY}
fi

echo "Backing up to ${BACKUP_DIRECTORY}"

mkdir -p ${BACKUP_DIRECTORY}

if [ -f "$BACKUP_DIRECTORY/backup.lock" ]; then
    echo "Backup is in progress. If this is an error delete the backup.lock file in $BACKUP_DIRECTORY"
fi

touch $BACKUP_DIRECTORY/backup.lock

if [ $? -ne 0 ]; then
    echo "Could not create lock file in "$BACKUP_DIRECTORY", please check the permissions"
    exit
fi

if [ -z $BACKUP_BASE_NAME ]; then
    echo "No backup base name has been set; examples are 'nginx', 'vaultwarden' or 'mariadb'"
    rm $BACKUP_DIRECTORY/backup.lock
    exit
fi

BACKUP_FILE_NAME=${BACKUP_BASE_NAME}"-"$(date +%F_%H-%M-%S)".tgz"

BACKUP_FILE_PATH=${BACKUP_DIRECTORY}"/"${BACKUP_FILE_NAME}

if [ ! -d "/data" ]; then
    echo "Folder to be backed up does not exist. The folder you want backed up should be available at /data"
    rm $BACKUP_DIRECTORY/backup.lock
    exit
fi

cd /data

tar -czpf $BACKUP_FILE_PATH .

rm $BACKUP_DIRECTORY/backup.lock

if [ -z $BACKUP_RETENTION ]; then
    echo "Please set BACKUP_RETENTION or else backups won't be pruned."
    exit
fi

ls -rt $BACKUP_DIRECTORY/${BACKUP_BASE_NAME}-* | head -n -${BACKUP_RETENTION} | xargs --no-run-if-empty rm
