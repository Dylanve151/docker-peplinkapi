FROM debian
RUN apt-get update && apt-get install -y \
  curl \
  cron \
  jq \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /root
ENV API_ClientID
ENV API_ClientSecret
ENV API_RedirectUri
COPY apitoken.sh .
COPY wakeup.sh .
RUN touch log.log
RUN chmod 755 *.sh
CMD [ "./addcronjob.sh" ]
