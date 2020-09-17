# docker-peplinkapi
deploy:
```
docker build --name="PeplinkAPI" --restart="always" --volume="/etc/localtime:/etc/localtime:ro" dylanve115/peplinkapi
```
## Environment variables:
### Required:
API_ClientID = 

API_ClientSecret = 

API_GrantType = **client_credentials** or **authorization_code** (**client_credentials** is default. **client_credentials** requires no interaction)

API_RedirectUri = For example: https://peplink.com (Only required when using **authorization_code**. **authorization_code** requires interaction)

### Optional:
 
api_server_prefix = By default https://api.ic.peplink.com for use with https://incontrol2.peplink.com

## Volumes:
sycning time with host: /etc/localtime:/etc/localtime:ro
Bind to folder with scripts: /scripts
