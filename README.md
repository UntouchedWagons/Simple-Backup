## Simple Backup

Simple Backup is an extremely simple backup service for Docker and Kubernetes containers.

Backups by default are made every 15 minutes and produce a tgz file. Do not use this with database containers like Postgresql or MariaDB, use their purpose-built backup solutions.

### Usage

#### Docker

    services:
      backup:
        image: UntouchedWagons/Simple-Backup:latest
        container_name: backup
        restart: unless-stopped
        environment:
          - BACKUP_DIRECTORY=/backups # Base folder for backups, defaults to /backups
          - BACKUP_APPEND_DIRECTORY=/some/sub/path # Optional, DO NOT include quotes
          - BACKUP_BASE_NAME=Nginx # Required
          - BACKUP_RETENTION=24 # Required
          - BACKUP_FREQUENCY="*/15 * * * *" # Optional, defaults to the value shown here
          - PUID=1000 # Optional, backup script is ran using this PUID, defaults to 0
          - PGID=1000 # Optional, backup script is ran using this PGID, defaults to 0
        volumes:
          - /path/to/data/source:/data
          - /path/to/backup/storage:/backups

Backups will be stored in `/backups` if `BACKUP_APPEND_DIRECTORY` is not set. If `BACKUP_APPEND_DIRECTORY` is set, the path specified will be appended and the backups will be stored in that folder. Using the sample path and base name above the script will produce `Nginx-2023-09-28_20-30-00.tgz` in the folder `/backups/some/sub/path`.

The command to prune excess backups isn't terribly smart but it should be safe to store backups of many different containers in the same folder.

### Additional options

As of 1.1.0 the environment variable `USE_CRON` has been added with a default value of `true`. When this variable is set to `false` the backup script is run immediately then the container exits.

As of 1.2.0 the environment variables `PUID` and `PGID` have been added with a default value of `0`. The backup script runs as PUID:PGID
