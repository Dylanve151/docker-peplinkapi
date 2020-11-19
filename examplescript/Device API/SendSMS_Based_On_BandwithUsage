#!/bin/bash
## Example of device API call script
## Send sms when bandwith allawance hits cetain percentage

# please change these variables
smsnumber="1280"
smsmessage="NOG 1GB"
repeatsms="5"
connid="2"
simid="1"
percentage="90"

## Token file
access_token_file="${HOME}/.access_token"
access_token=$(cat ${access_token_file})

tmpfile="/tmp/ic2.tmpfile.$$"

api_server_prefix=$(cat /verbs/api_server_prefix)
curl_opt=" -k "

token_params="accessToken=${access_token}"
billingcycle_params="&connId=${connid}&simId=${simid}"
sendsms_params="&connId=${connid}&address=${smsnumber}&content=${smsmessage}"

echo "Checking monthly allowance..."
curl $curl_opt -so $tmpfile --data "${token_params}" "${api_server_prefix}/api/status.wan.connection.allowance"

if grep -q Unauthorized $tmpfile ; then
      echo "The saved access token is invalid.  Rerun this script to obtain a new one"
      rm -f ${access_token_file}
      exit 7
fi

percentusage=$(jq -r ".response.\"${connid}\".\"${simid}\".percent" $tmpfile)
#mbsused=$(jq -r ".response.\"${connid}\".\"${simid}\".usage" $tmpfile)
if [ "${percentusage}" -gt "${percentage}" ] ; then
	echo "Monthly allowance more then ${percentage}% used"
	for ((n=0;n<"${repeatsms}";n++)); do
		curl $curl_opt -so $tmpfile --data "${token_params}${sendsms_params}" "${api_server_prefix}/api/cmd.sms.sendMessage"
	done
	stat=$(jq -r ".stat" $tmpfile)
	if [ "${stat}" == "ok" ] ; then
		echo "SMS has been send"
		curl $curl_opt -so $tmpfile --data "${token_params}${billingcycle_params}" "${api_server_prefix}/api/cmd.billing.newCycle"
		stat=$(jq -r ".stat" $tmpfile)
		if [ "${stat}" == "ok" ] ; then
			echo "Billing cycle has been reset"
		else
			echo "FAIL. Billing cycle has NOT been reset"
		fi
	else
		echo "FAIL. SMS has NOT been send"	
	fi
else
	echo "Monthly allowance ${percentusage}% used"
fi
rm -f $tmpfile
