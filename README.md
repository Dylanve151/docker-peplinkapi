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

API_RedirectUri = For example: https://peplink.com

### Optional:
 
api_server_prefix = For example: https://api.ic.peplink.com
