#!/bin/bash
#startup script

echo "$API_Clienttype" > /verbs/API_Clienttype
echo "$API_ClientID" > /verbs/API_ClientID
echo "$API_ClientSecret" > /verbs/API_ClientSecret
echo "$API_GrantType" >  /verbs/API_GrantType
echo "$API_RedirectUri" > /verbs/API_RedirectUri
echo "api_server_prefix" > /verbs/api_server_prefix

service cron start
tail -f log.log
