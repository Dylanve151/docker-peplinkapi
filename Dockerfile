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
COPY startup.sh .
COPY apitoken.bash .
COPY crontab-template .
RUN mkdir /verbs
RUN echo "* * * * * /root/apitoken.bash >> /root/log.log"$'\n' > /etc/cron.d/gen_apitoken
RUN echo "* * * * * SCRIPTS=/scripts/*.sh; for f in $SCRIPTS; do sh \"$f\"; done >> /root/log.log"$'\n' > /etc/cron.d/scripts
RUN touch log.log
RUN chmod 755 startup.sh
RUN chmod 755 apitoken.bash
CMD ["./startup.sh"]
