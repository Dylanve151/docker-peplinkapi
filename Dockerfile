FROM debian
RUN apt-get update && apt-get install -y \
  curl \
  cron \
  jq \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /root
ENV API_ClientID YourClientID
ENV API_ClientSecret YourClientSecret
ENV API_RedirectUri YourRedirectUri
ENV api_server_prefix https://api.ic.peplink.com
COPY apitoken.sh .
RUN touch log.log
RUN chmod 755 *.sh
CMD [ "./addcronjob.sh" ]
