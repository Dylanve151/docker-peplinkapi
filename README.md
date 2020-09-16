# docker-scheduledwol
deploy:
```
docker build --name="Scheduled-WOL" --restart="always" --volume="/etc/localtime:/etc/localtime:ro" --network="host"  dylanve115/scheduledwol
```
## Environment variables:
### Required:
BROADCAST_IP = Broadcast ip of your network. (usually ends with 255 for Example: "192.168.1.255").

MAC_ADDRESS = Mac address of PC you want to wake up (Format: "00:00:00:00:00:00").

CRONTIME = Set the time in CRONTAB to schedule the wakeup script. (Example: "0 12 * * *" starts wakeup script everyday on 12:00).

### Optional:
TRIGGER_IP = Set a IP to trigger when it this IP comes online while wakeup script is active (I used my phone ipaddres for Example: "192.168.1.150").

## Example of CRONTIME definition:
```
.---------------- minute (0 - 59)
|  .------------- hour (0 - 23)
|  |  .---------- day of month (1 - 31)
|  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
|  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
|  |  |  |  |
*  *  *  *  *
```
