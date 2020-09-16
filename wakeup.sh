#!/bin/bash
#WOL

BROADCAST_IP=$(cat BROADCAST_IP)
MAC_ADDRESS=$(cat MAC_ADDRESS)
TRIGGER_IP=$(cat TRIGGER_IP)

echo "wakeup.sh script started" >> log.log
if [ -z "$TRIGGER_IP" ]
then
  echo "No trigger IP" >> log.log
  for MAC in $MAC_ADDRESS
  do
    wakeonlan -i $BROADCAST_IP $MAC >> log.log
  done
else
  echo "Waiting for trigger IP" >> log.log
  until ping -c1 $TRIGGER_IP &>/dev/null; do :; done
  for MAC in $MAC_ADDRESS
  do
    wakeonlan -i $BROADCAST_IP $MAC >> log.log
  done
fi
