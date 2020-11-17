#!/bin/bash

## Script for making IC2 and device API tokens
## Revision 1.3
## By Billy Lau, Michael Chan

## Modified by Dylan
## Last modified: 2020-11-17
## Modification: Modified for docker and also works with device API.

#
## Please input your InControl 2 OAuth client_id, client_secret and redirect_uri below
## You can optain a set of client ID and secret from your user profile page by clicking
## your email address on the top of the InControl 2 screen, scrolling to the "Client
## Application" section, clicking the "New Client" button, and filling in the form.
##
## For the redirect_uri, you may fill in http://www.peplink.com in the above form
## and the redirect_uri variable below
client_type$(cat /verbs/API_Clienttype)
client_id=$(cat /verbs/API_ClientID)
client_secret=$(cat /verbs/API_ClientSecret)
grant_type=$(cat /verbs/API_GrantType)
redirect_uri=$(cat /verbs/API_RedirectUri)
api_server_prefix=$(cat /verbs/api_server_prefix)

if [ -f "/root/.apiclient" ]
then
        client_id=$(sed -n 1p /root/.apiclient)
        client_secret=$(sed -n 2p /root/.apiclient)
fi

# For InControl 2, the api_server_prefix is https://api.ic.peplink.com.
# For InControl appliances, this is https://{SERVER_NAME_HERE}.
if [ -z "$api_server_prefix" ]
then
        api_server_prefix="https://api.ic.peplink.com"
fi

# For InControl 2, set 1 to verify the API service's SSL certificate.
# For InControl appliances without a valid SSL certificate, set this to 0 to ignore the certificate validity.
if [ "${client_type}" == "device" ]; then
        verify_ssl_cert=0
else
        verify_ssl_cert=1
fi

################# Code for OAuth2 token handling goes below ##################
access_token_file="${HOME}/.access_token"
refresh_token_file="${HOME}/.refresh_token"
tmpfile="/tmp/ic2.tmpfile.$$"
if [ "${client_type}" == "device" ]; then
        ic2_token_url="${api_server_prefix}/api/auth.token.grant"
else
        # InControl token endpoint
        ic2_token_url="${api_server_prefix}/api/oauth2/token"
        # InControl authorization endpoint
        ic2_auth_url="${api_server_prefix}/api/oauth2/auth?client_id=${client_id}&response_type=code"

        if [ "${client_id}" == "" ] || [ "${client_secret}" == "" ]; then
                echo "Please enter Client ID and Client Secret"
                exit 1
        fi

        if [ "${grant_type}" == "authorization_code" ] && [ "${redirect_uri}" == "" ]; then
                echo "Please enter redirect uri"
                exit 1
        fi
fi

# Check if jq has been installed
if ! command -v jq > /dev/null 2>&1 ; then
        echo "Error: Missing jq command."
        echo "Run \"apt install jq\" or \"yum install jq\" to install."
        exit 2
fi

if [ "$verify_ssl_cert" != "0" ]; then
        curl_opt=" -k "
else
        curl_opt=""
fi

if [ "${client_type}" == "device" ]; then
        function save_tokens() {
                result=$(jq -r .response)
                local -n access_token_tmp=$1
                access_token_tmp=`echo "${result}"|jq -r .accessToken`
                expires_in=`echo "${result}"|jq -r .expiresIn`
                if [ "${access_token_tmp}" == "" ]; then
                        echo "Unable to obtain an access token. Process aborted"
                        echo "Returned: $result"
                        exit 3
                fi
                # Save the access token and refresh token."
                echo ${access_token_tmp} > ${access_token_file}
                # Set the files' last modified date to the tokens' expiry date
                touch -d @$(( $(date +%s) + expires_in )) ${access_token_file}
        }
else
        function save_tokens() {
                result=$(cat)
                local -n access_token_tmp=$1
                local -n refresh_token_tmp=$2
                access_token_tmp=`echo "${result}"|jq -r .access_token`
                refresh_token_tmp=`echo "${result}"|jq -r .refresh_token`
                expires_in=`echo "${result}"|jq -r .expires_in`
                if [ "${access_token_tmp}" == "" ]; then
                        echo "Unable to obtain an access token. Process aborted"
                        echo "Returned: $result"
                        exit 3
                fi
                # Save the access token and refresh token."
                echo ${access_token_tmp} > ${access_token_file}
                echo ${refresh_token_tmp} > ${refresh_token_file}
                # Set the files' last modified date to the tokens' expiry date
                touch -d @$(( $(date +%s) + expires_in )) ${access_token_file}
                touch -d @$(( $(date +%s) + expires_in + 30*60*60 )) ${refresh_token_file}
        }
fi

# If the access token file has not expired
if [ -f ${access_token_file} ] && [ $(stat -c %Y ${access_token_file}) -gt $(date +%s) ]; then
        access_token=$(cat ${access_token_file})
# If the access token is invalid but the refresh token has not expired, acquire new access and refresh tokens
elif [ -f ${refresh_token_file} ] && [ $(stat -c %Y ${refresh_token_file}) -gt $(date +%s) ]; then
        ic2_token_params="client_id=${client_id}&client_secret=${client_secret}&grant_type=refresh_token&refresh_token=$(cat ${refresh_token_file})"
        curl $curl_opt -so $tmpfile -X POST -d "$ic2_token_params" "${ic2_token_url}"
        if ! save_tokens access_token refresh_token < $tmpfile; then
                rm -f $tmpfile
                exit 4
        fi
else
        if [ "${grant_type}" == "authorization_code" ] || [ "${client_type}" != "device" ]; then
                echo ""
                echo "Start a web browser, visit the following URL and follow the instructions."
                echo ""
                echo "${ic2_auth_url}"
                echo ""
                echo "You will be redirected to $redirect_uri?code=CODE_HERE."
                echo -n "Please enter the 'code' in the redirected URL here: "
                read code

                if [ "${code}" == "" ]; then
                        echo "Error: The code is empty.  Process aborted"
                        exit 5
                fi

                ic2_token_params="client_id=${client_id}&client_secret=${client_secret}&grant_type=authorization_code&code=${code}&redirect_uri=${redirect_uri}"
        ## No interaction needed
        else
                if [ "${client_type}" == "device" ]; then
                        ic2_token_params="clientId=${client_id}&clientSecret=${client_secret}&scope=api"
                else
                        ic2_token_params="client_id=${client_id}&client_secret=${client_secret}&grant_type=client_credentials"
                fi
        fi

        ## POST data to token endpoint
        curl $curl_opt -so $tmpfile --data "${ic2_token_params}" "${ic2_token_url}"
        if ! save_tokens access_token refresh_token < $tmpfile; then
                rm -f $tmpfile
                exit 6
        fi
fi
rm -f $tmpfile

## runs every file ending with .sh in the /scripts folder
#SCRIPTS=/scripts/*.sh
#for f in $SCRIPTS
#do
#        sh "$f"
#done
