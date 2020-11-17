FROM debian
RUN apt-get update && apt-get install -y \
  curl \
  cron \
  jq \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /root
VOLUME ["/scripts"]
ENV API_Clienttype ic2
ENV API_ClientID ClientID
ENV API_ClientSecret ClientSecret
ENV API_RedirectUri https://peplink.com
ENV API_GrantType client_credentials
ENV api_server_prefix https://api.ic.peplink.com
COPY apitoken.sh .
COPY crontab-template .
RUN mkdir /verbs
RUN crontab -u root crontab-template
RUN touch log.log
RUN chmod 755 *.sh
CMD ["./startup.sh"]
