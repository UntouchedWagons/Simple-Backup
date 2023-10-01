FROM debian:bookworm-slim
LABEL org.opencontainers.image.authors="untouchedwagons@fastmail.com"

COPY scripts/backup.sh /root/backup.sh
COPY scripts/run.sh /root/run.sh

RUN chmod 0744 /root/backup.sh /root/run.sh
RUN apt-get update && apt-get -y install cron nano && touch /var/log/cron.log

ENV BACKUP_DIRECTORY="/backups"
ENV BACKUP_APPEND_DIRECTORY=""
ENV BACKUP_BASE_NAME=""
ENV BACKUP_RETENTION="24"
ENV BACKUP_FREQUENCY="*/15 * * * *"

CMD ["/root/run.sh"]
