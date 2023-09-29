## Simple Backup

Simple Backup is an extremely simple backup service for Docker and Kubernetes containers.

Backups are made every 15 minutes and produce a tgz file. Do not use this with database containers like Postgresql or MariaDB, use their purpose-built backup solutions.

### Usage

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

Backups will be stored in `/backups` if `BACKUP_APPEND_DIRECTORY` is not set. If `BACKUP_APPEND_DIRECTORY` is set, the path specified will be appended and the backups will be stored in that folder. Using the sample path and base name above the script will produce `Nginx-2023-09-28_20-30-00.tgz` in the folder `/backups/some/sub/path`.

The command to prune excess backups isn't terribly smart but it should be safe to store backups of many different containers in the same folder.
