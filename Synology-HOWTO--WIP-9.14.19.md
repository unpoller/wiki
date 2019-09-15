[DO NOT FOLLOW THESE INSTRUCTIONS THEY ARE UNDER CONSTRUCTION]

# Introduction
this needs some pithy observations and scene settings on this not being best way but a way
and why we do some things differently because 'reasons' (aka synology)

Assumptions:
1. You already installed docker from package center
2. You already enabled SSH on your synology <insert link to SSH instructions elsewhere>

# Prepare your unifi controller
1. Add a user to the UniFi Controller. After logging into your controller:
2. Go to Settings -> Admins
3. Add a read-only user (e.g. 'influx') with a nice long password.
4. The new user needs access to each site. For each UniFi Site you want to poll, add admin via the 'Invite existing admin' option.
Take note of this info, you need to put it into the unifi-poller config file in a moment

# Prepare Synology & Docker
## Run docker & configure network
Click on network and select add to create new network:
1. Name it something like Grafana_Net
2. Enable IPv4
3. Ensure 'Get  network configuration automatically'is selected
4. click add

We do this because the default bridge doesn't have name resolution but new bridge do, so you don't have to mess with host files etc inside the container. <need to verify this is actually true>.

I don't recommend you use host network, using the bridge network keeps it self contained at helps avoid conflicts with the host or other containers you might have that we cannot predict.
## prepare mapped volumes
1. Create the following structure in your preferred location (mine is a shared folder called docker) <note i am not sure which you absolutely need to precreate might be good to test - hmm the structure below does not render correctly>
/docker/grafana  and /docker/influxdb


## Download needed images from the registry
1. select registry
2. use search box to find the following
* golift/unifi-poller:latest   https://hub.docker.com/r/golift/unifi-poller/ <should we use stable?>
* grafana/grafana:latest https://hub.docker.com/r/grafana/grafana/ <should we use stable?>
* influxdb:latest https://hub.docker.com/_/influxdb/

# Create influxdb container
1. In image select influxdb:latest and click launch
2. leave general settings alone - container name should be influxdb1 unless you created other influxdb's
3. Click advanced settings
4. on volume tab add the following:
* docker/influxdb folder to mount path /var/lib/influxdb leave as read/write
5. on the network tab
* remove the default bridge (usually called bridge)
* add your network, in this example, Grafana_Net
* Ensure that 'use the same network as docker host' is unchecked
6. on port settings
*change local port from Auto to one you have free on host - this makes it predictable. something like 3456
*leave container port as 8086 and type as TCP
7. on environment tab add the following vars
* INFLUXDB_DATA_DIR       = /var/lib/influxdb/data
* INFLUXDB_DATA_WAL_DIR   = /var/lib/influxdb/wal
* INFLUXDB_DATA_META_DIR  = /var/lib/influxdb/meta
9 Finalize container and run
* Click APPLY click NEXT click APPLY

# Create influx databse
1 click containers and then double click the running influxdb1 container
2 switch to the terminal tab
3 click the drop down next to create and 'select launch with command'
4 enter bash and click ok
5 select bash from the left hand side - you should now see a command prompt
6 in the command prompt enter these commands (note you can't cut and paste)
* 'influx' - after a couple of second you should be in the InfluxDB shell.  enter them exactly as shown
* CREATE DATABASE unifi
* USE unifi
* CREATE USER unifi WITH PASSWORD 'unifi' WITH ALL PRIVILEGES
* GRANT ALL ON unifi TO unifi

#create unifi-poller container
1. In image select golift/unifi-poller:latest and click launch
2. leave general settings alone - container name should be golift-unifi-poller1 unless you created other iunifi-pollers
3. Click advanced settings
4. on the network tab
* remove the default bridge (usually called bridge)
* add your network, in this example, Grafana_Net
* Ensure that 'use the same network as docker host' is unchecked
5. on environment tab add the following vars
* UP_INFLUX_URL = influxdb1
* UP_UNIFI_URL = https://<your unifi controller ip>:8443
* UP_UNIFI_USER = <username for the read on account you created in the unifi controller earlier e.g. influx>
* UP_UNIFI_PASS = <password for the above user>
9 Finalize container and run
* Click APPLY click NEXT click APPLY

#check that poller and influx are working
1. select container in docker UI
2. double click golift-unifi-poller1
3. select log tab
4. after a couple of minutes you should see an entry like the following, if you do then everything is working ok
`2019/09/14 22:43:09 [INFO] UniFi Measurements Recorded. Sites: 1, Clients: 78, Wireless APs: 6, Gateways: 1, Switches: 6, Points: 193, Fields: 7398`

# Grafana
This container is a little difficult on synology, there are two methods that have been to shown to work.  If you have an even better method let us know!  The two different methods have their pros and cons.

Options:

**Method 1** - create container in UI, use SSH on the synology to change some file permissions.  Advantages - the docker clean action in the UI continues to work.  Disadvantages - be careful not to break the container by modifying folder attributes in the UI.

**Method 2** - create container via SSH command on the synology to create the container.  Advantage no need to change file system ownership attributes. Disadvantages - have to create a user account and delete the container and re-run the docker command each time you want to update the base image.

## Method 1
to be completed

## Method 2
1. Create a new user account on the synology from control panel
* Call the user grafana
* set their password (you don't need to logon as grafana and change it)
* disallow password change
* assign them to the user group users
* give them r/w permission to the folder you created e.g. /docker/grafana
* don't assign them anything else
2 SSH into your synology (if you don't know how to do that see this link <link>)
3 Run the following command to fin the PID of the user you created:
`sudo id grafana
4. now run the following command.  NOTE use the pid you got in step 3, use the network name you created if you didn't use Grafana_Net AND you will need to use the volume # your docker folder (the one you created manually is on)  by default this will be on volume1 but if you have multiple volumes this may not be the case.
`sudo docker run --user 1031 --name grafana-grafana1 --net=Grafana_Net -p 300:3000 --volume /volume1/docker/grafanatest:/var/lib/grafana -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-piechart-panel,natel-discrete-panel" grafana/grafana:latest`

At this point your container should have created ok, 

If so start the container, the first time it should take a while to intialize the database.  Check the logs to make sure you have no file / folder permissions issues.  If you did you will need to check you used the right PID and set the ownership of the host grafana folder correctly.

From you host browser access http://localhost:3000 and you should see the grafana logon (the default is admin:admin)
### Notes
notes?
<critical notes about this method>

## Configuring Grafana datasource
<fill this section with the instruction on selecting the data source - i.e step by step of how to add source and to use the server name as influxdb1>

## Importing the default dahsboards.
<fill this section with the instruction on importing the dashboards - i found using thee dahsboard ID from the grafana site and using that simple ID to do the import was easiest even though not documented elsewhere here>

[DO NOT FOLLOW THESE INSTRUCTIONS THEY ARE UNDER CONSTRUCTION]
