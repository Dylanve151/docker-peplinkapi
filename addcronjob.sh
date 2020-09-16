#!/bin/bash
#crontab time

if [ -z "$CRONTIME" ]
then
	echo "No Crontime" >> log.log
else
	echo "$CRONTIME root /root/wakeup.sh >> /root/log.log"$'\n' > /etc/cron.d/wakeup
fi
echo "$BROADCAST_IP" > BROADCAST_IP
echo "$MAC_ADDRESS" > MAC_ADDRESS
if [ -z "$TRIGGER_IP" ]
then
	echo "No Trigger IP" >> log.log
else
	echo "$TRIGGER_IP" > TRIGGER_IP
fi
service cron start
tail -f log.log
