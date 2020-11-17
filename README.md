# docker-peplinkapi
deploy:
```
docker build --name="PeplinkAPI" --restart="always" --volume="/etc/localtime:/etc/localtime:ro" dylanve115/peplinkapi
```
## Environment variables:
### Required:
API_ClientID = 

API_ClientSecret = 

API_GrantType = **client_credentials** or **authorization_code** (Default: **client_credentials** (requires no interaction))

### Optional:

API_RedirectUri = For example: https://peplink.com (Only required when using **authorization_code** (requires interaction))

API_clienttype = **device** or **ic2** (Default: **ic2** when using incontrol2 api. **device** when using device api.)
 
api_server_prefix = By default https://api.ic.peplink.com for use with https://incontrol2.peplink.com

## Volumes:
sycning time with host: /etc/localtime (use as /etc/localtime:/etc/localtime:ro)

Bind to folder with scripts: /scripts (make sure you save scripts as unix not as dos/windows)

Bind to folder to edit crontab: /var/spool/cron/crontabs (make sure you save crontab files as unix not as dos/windows)
