## Simple Backup

Simple Backup is an extremely simple backup service for Docker and Kubernetes containers.

Backups are made every 15 minutes and produce a tgz file. Do not use this with database containers like Postgresql or MariaDB, use their purpose-built backup solutions.

### Usage

#### Docker

    ---
    version: "2.1"
        services:
            backup:
                image: UntouchedWagons/Simple-Backup:1.0.0
                container_name: backup
                restart: unless-stopped
                environment:
                    - BACKUP_APPEND_DIRECTORY=/some/sub/path #Optional, DO NOT include quotes
                    - BACKUP_BASE_NAME=Nginx #Required
                    - BACKUP_RETENTION=24 #Required
                volumes:
                    - /path/to/data/source:/data
                    - /path/to/backup/storage:/backups

#### Kubernetes

    containers:
    - name: backup
        image: untouchedwagons/simple-backup:1.0.5
        resources:
        limits:
            memory: 256Mi
            cpu: "1"
        requests:
            memory: 128Mi
            cpu: "0.2"
        volumeMounts:
        - mountPath: /data
            name: vaultwarden-config
        - mountPath: /backups
            name: backups
        env:
        - name: BACKUP_APPEND_DIRECTORY
            value: "/some/sub/path"
        - name: BACKUP_BASE_NAME
            value: "Nginx"

Backups will be stored in `/backups` if `BACKUP_APPEND_DIRECTORY` is not set. If `BACKUP_APPEND_DIRECTORY` is set, the path specified will be appended and the backups will be stored in that folder. Using the sample path and base name above the script will produce `Nginx-2023-09-28_20-30-00.tgz` in the folder `/backups/some/sub/path`.

The command to prune excess backups isn't terribly smart but it should be safe to store backups of many different containers in the same folder.

### Additional options

As of 1.1.0 the environment variable `USE_CRON` has been added with a default value of `true`. When this variable is set to `false` the backup script is run immediately then the container exits.
