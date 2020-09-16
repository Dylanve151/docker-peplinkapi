FROM debian
RUN apt-get update && apt-get install -y \
  wakeonlan \
  cron \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /root
ENV BROADCAST_IP 192.168.1.255
ENV CRONTIME 0 12 * * *
ENV MAC_ADDRESS 00:00:00:00:00:00
COPY addcronjob.sh .
COPY wakeup.sh .
RUN touch log.log
RUN chmod 755 *.sh
CMD [ "./addcronjob.sh" ]
