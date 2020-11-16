#!/bin/bash
#startup script

echo "$API_ClientID" > /verbs/API_ClientID
echo "$API_ClientSecret" > /verbs/API_ClientSecret
echo "$API_GrantType" >  /verbs/API_GrantType
echo "$API_RedirectUri" > /verbs/API_RedirectUri

service cron start
tail -f log.log
