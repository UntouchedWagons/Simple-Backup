FROM debian:bookworm-slim
LABEL org.opencontainers.image.authors="untouchedwagons@fastmail.com"

COPY scripts/backup.sh /root/backup.sh
COPY scripts/run.sh /root/run.sh
COPY cron/backup-cronjob /tmp/backup-cronjob

RUN chmod 0744 /root/backup.sh /root/run.sh
RUN apt-get update && apt-get -y install cron nano && touch /var/log/cron.log

CMD ["/root/run.sh"]
