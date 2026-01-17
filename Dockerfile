FROM debian:trixie-slim
LABEL org.opencontainers.image.authors="untouchedwagons@fastmail.com"

COPY scripts/run.sh /root/run.sh
COPY scripts/backup.sh /tmp/backup.sh

RUN chmod 0700 /root/run.sh 
RUN chmod 0755 /tmp/backup.sh

RUN apt-get update && apt-get -y install cron nano && touch /var/log/cron.log

ENV BACKUP_DIRECTORY="/backups"
ENV BACKUP_APPEND_DIRECTORY=""
ENV BACKUP_BASE_NAME=""
ENV BACKUP_RETENTION="24"
ENV BACKUP_FREQUENCY="*/15 * * * *"
ENV PUID=0
ENV PGID=0
ENV USE_CRON=true

CMD ["/root/run.sh"]
