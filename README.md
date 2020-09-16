# docker-peplinkapi
deploy:
```
docker build --name="" --restart="always" --volume="/etc/localtime:/etc/localtime:ro" dylanve115/
```
## Environment variables:
### Required:
API_ClientID = 

API_ClientSecret = 

API_GrantType = authorization_code or client_credentials (client_credentials recomended. requires no interaction)

API_RedirectUri = For example: https://peplink.com

### Optional:
 
api_server_prefix = For example: https://api.ic.peplink.com
