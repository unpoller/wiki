## Introduction

We are not claiming this is the only way to do this.
However this is designed to use the official packages for UniFi Poller,
InfluxDB and Grafana with the aim to make this maintainable as possible.

We use a custom bridge network for some very good reasons and we **highly recommend** most people use it:

-   This ensures name resolution works between the containers without needing to use the deprecated link functionality
-   The default bridge on docker does NOT have name resolution enabled and requires
    mucking about with host files (this is a docker feature not anything to do with Synology)
-   This also means in the event the container IP changes (it happens) you don't need to reconfigure
-   This also means, due to the ICC, that no host port mappings are required other than for the Grafana
    3000:3000 mapping in the Grafana contained, you can choose to remove other port mappings if you desire
-   The reason for not using host port mappings for container <> container comms is we keep this solution
    self-container and don't have to worry about weird things that might have been on the Synology
    (changing of Synology IP, other containers with host mappings etc). Customize in your environment as needed.

These instructions will let you use the Synology docker `stop container action` > `clear container action` >
`re-download the image` > `restart container` to update to the latest.
**_<---this still needs to be tested to confirm 100% - we may need to map in some more grafana dirs._**

-   **NOTE**: If you want to use this flow for updates you will need to use Method 1 for Grafana documented here.

Assumptions:

1.  [You already installed Docker from package center.](https://www.synology.com/en-us/dsm/packages/Docker)
1.  [Enable SSH on Synology](https://www.synology.com/en-global/knowledgebase/DSM/help/DSM/AdminCenter/system_terminal)
-   _Note:_ you should always logon with your default admin account you created when you setup you Synology,
    logging on as root no longer works.

## Prepare your UniFi controller

1.  Add a user to the UniFi Controller. After logging into your controller:
1.  Go to Settings -> Admins
1.  Add a read-only user (e.g. `unifipoller`)
1.  The new user needs access to each site. For each UniFi Site you want to poll,
    add admin via the 'Manually Set and Share the password' option. Other settings:
-   don't define an email
-   don't require password to be changed
-   use only uppercase, lowercase, numerals and the ! symbol and limit to 10 chars or less (some have had
    issues with anything else, once you have it all working feel free to play with longer more complex passwords)

Take note of this info, you need to put it into the unifi-poller config file in a moment

## Prepare Synology & Docker

### Run docker & configure network

Click on network and select add to create new network:

1.  Name it something like Grafana_Net
1.  Enable IPv4
1.  Ensure 'Get network configuration automatically' is selected
1.  Click add

We do this because the default bridge doesn't have name resolution but new bridge do,
so you don't have to mess with host files etc inside the container. (need to verify this is actually true)

I don't recommend you use host network, using the bridge network keeps it self contained
at helps avoid conflicts with the host or other containers you might have that we cannot predict.

### Prepare mapped volumes

1.  Create the following structure in your preferred location (mine is a shared folder
    called docker) <note i am not sure which you absolutely need to pre-create might be
    good to test - hmm the structure below does not render correctly>
    -   `/docker/grafana`  and `/docker/influxdb`

### Download needed images from the registry

1.  select registry
1.  use search box to find the following
-   `golift/unifi-poller:latest` [https://hub.docker.com/r/golift/unifi-poller/](https://hub.docker.com/r/golift/unifi-poller/)
-   `grafana/grafana:latest` [https://hub.docker.com/r/grafana/grafana/](https://hub.docker.com/r/grafana/grafana/)
-   `influxdb:latest` [https://hub.docker.com/_/influxdb/](https://hub.docker.com/_/influxdb/)

### Create influxdb container

1.  In image select `influxdb:latest` and click launch
1.  leave general settings alone - container name should be influxdb1 unless you created other influxdb's
1.  Click advanced settings
1.  on volume tab add the following:
    -   docker/influxdb folder to mount path /var/lib/influxdb leave as read/write
1.  on the network tab
    -   add your network, in this example, Grafana_Net
    -   remove the default bridge (usually called bridge)
    -   Ensure that 'use the same network as docker host' is unchecked
1.  on port settings **<--- why do i have host mapped port, not sure we need this for
    this set of 3 as all traffic is internal**
    -   change local port from Auto to one you have free on host - this makes it predictable. something like 3456
    -   leave container port as 8086 and type as TCP
1.  on environment tab add the following vars
    -   INFLUXDB_DATA_DIR       = /var/lib/influxdb/data
    -   INFLUXDB_DATA_WAL_DIR   = /var/lib/influxdb/wal
    -   INFLUXDB_DATA_META_DIR  = /var/lib/influxdb/meta
1.  Finalize container and run
    -   Click APPLY click NEXT click APPLY

#### Create influx database

1.  click containers and then double click the running influxdb1 container
1.  switch to the terminal tab
1.  click the drop down next to create and 'select launch with command'
1.  enter bash and click ok
1.  select bash from the left hand side - you should now see a command prompt
1.  in the command prompt enter these commands (note you can't cut and paste)
-   `influx` - after a couple of second you should be in the InfluxDB shell.  enter them exactly as shown
-   `CREATE DATABASE unifi`
-   `USE unifi`
-   `CREATE USER unifipoller WITH PASSWORD 'unifipoller' WITH ALL PRIVILEGES`
-   `GRANT ALL ON unifi TO unifi`

#### Note

-   We have not used any advanced aut setting of influx, this is for simplicity of instructions and
    tbh the data in this is not critical, if you have someone on your network who is malicious and
    figures out how to route into the containers you have bigger issues at hand.... you can remove
    the influxdb port mapping if that makes you feel better.... :-)

### Create unifi-poller container

1.  In image select golift/unifi-poller:latest and click launch
1.  leave general settings alone - container name should be `golift-unifi-poller1` unless you created other unifi-pollers
1.  Click advanced settings
1.  on the network tab
    -   add your network, in this example, `Grafana_Net`
    -   remove the default bridge (usually called bridge)
    -   Ensure that 'use the same network as docker host' is unchecked
1.  on environment tab add the following vars
    -   UP_INFLUXDB_URL = `http://influxdb1:8086`
    -   UP_UNIFI_DEFAULT_URL = `https://your.unifi.controller.ip:8443`
    -   UP_UNIFI_DEFAULT_USER = `username for account created earlier. e.g. unifipoller`
    -   UP_UNIFI_DEFAULT_PASS = `password for above user`
    -   (optional) UP_POLLER_DEBUG = `true`
1.  Finalize container and run
    -   Click APPLY click NEXT click APPLY

#### Check that poller and influx are working

1.  Select container in docker UI
1.  Double click `golift-unifi-poller1`
1.  Select log tab
1.  After a couple of minutes you should see an entry like the following,
    if you do then everything is working ok

      ```shell
    2019/09/14 22:43:09 [INFO] UniFi Measurements Recorded. Sites: 1, Clients: 78, Wireless APs: 6, Gateways: 1, Switches: 6, Points: 193, Fields: 7398
    ```

### Grafana Container

This container is a little difficult on Synology, there are two methods that have
been to shown to work.  If you have an even better method let us know!
The two different methods have their pros and cons.

Options:

**Method 1** - create container in UI, use SSH on the Synology to change some file permissions.

-   `Advantages` - the docker clean action in the UI continues to work.
-   `Disadvantages` - be careful not to break the container by modifying folder attributes in the UI.

**Method 2** - create container via SSH command on the Synology to create the container.

-   `Advantages` - no need to change file system ownership attributes.
-   `Disadvantages` - have to create a user account and delete the container and re-run the docker
    command each time you want to update the base image.

#### Method 1 - Recommended

##### Method 1 Preparation

1.  SSH into your Synology
1.  You will need to CD to the root docker directory you created earlier
    (in this example the /docker folder containing the `/grafana` folder.
1.  The command format is cd `/volume{x}/{dirname}` on my system this shared folder
    is on volume 3 so for me it is: `cd /volume3/docker`
1.  Now you need to change the permissions of the grafana folder: `sudo chown 472 grafana`

-   **NOTE**: If you look at the grafana folder ownership in file station it will say
    472 rather than any user you have created.

##### Method 1 Container

1.  In image select grafan/grafana:latest and click launch
1.  leave general settings alone - container name should be `grafana-grafana1` unless you created other grafanas
1.  Click advanced settings
1.  on volume tab add the following:
    -   `docker/grafana` folder to mount path `/var/lib/grafana` leave as `read/write`
1.  on the network tab
    -   add your network, in this example, `Grafana_Net`
    -   remove the default bridge (usually called `bridge`)
    -   Ensure that 'use the same network as docker host' is unchecked
1.  on port settings
    -   change local port from Auto to one you have free on host - this makes it predictable. something like `3000`
    -   leave container port as `3000` and type as `TCP`
1.  on environment tab add the following vars
    -   `GF_INSTALL_PLUGINS = grafana-clock-panel,grafana-piechart-panel,natel-discrete-panel`
1.  Finalize container and run
    -   Click APPLY click NEXT click APPLY

-   **NOTE**: Don't change ownership in file station of the Grafana folder or you will break the container.
-   **_Skip to 'running the container section below'_**

#### Method 2

##### Method 2 Preparation

1.  Create a new user account on the Synology from control panel
    -   Call the user grafana
    -   Set their password (you don't need to logon as grafana and change it)
    -   Disallow password change
    -   Assign them to the user group users
    -   Give them r/w permission to the folder you created e.g. /docker/grafana
    -   Don't assign them anything else
1.  SSH into your Synology
1.  Run the following command to find the PID of the user you created and note it for later: `sudo id grafana`

##### Method 2 Container

-   Run the following command.

    ```shell
    sudo docker run --user 1031 --name grafana-grafana1 \
      --net=Grafana_Net -p 300:3000 \
      --volume /volume1/docker/grafanatest:/var/lib/grafana \
      -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-piechart-panel,natel-discrete-panel" \
      grafana/grafana:latest
    ```

-   **Use the pid you got in step 3 above**, use the network name you created if you didn't use `Grafana_Net`
    AND you will need to use the volume # your docker folder (the one you created manually is on)
    by default this will be on volume1 but if you have multiple volumes this may not be the case.

##### Method 2 Notes

-   If you use the clean action in the Synology docker UI you will break this VM and need to
    delete and rerun the docker run command.
-   If you use the Synology docker UI to export the configuration and import it again later the
    docker will break and you will need to rerun the docker run command.
-   I have no idea if hyperbackup or any other backup / restore will also break the config
-   This all derives from the fact there is no way to do `--user {PID}` in the Synology docker UI / JSON.

#### Running the container

At this point your container should have created ok,

If so start the container, the first time it should take a while to initialize the database.
Check the logs to make sure you have no file / folder permissions issues. If you did you will
need to check you used the right PID and set the ownership of the host grafana folder correctly.

From you host browser access `http://{ip address of your synology}:3000` and you should see the
Grafana logon (the default is admin:admin)

You will be prompted to change the default password, do so.

## Configuring InfluxDB Grafana Datasource

1.  Click add data source on the page you see after logon.
1.  Select the influxdb icon
1.  Set the following fields:
    -   Name = UniFi InfluxDB  (or whatever name you want) and set to default
    -   URL = `http://influxdb1:8086`
    -   Database = unifi
    -   Username = unifipoller
    -   Password = unifipoller
1.  **No other fields need to be changed or set on this page.**
1.  Click save & test
    -   You should get green banner above the save and test that says 'Data Source is Working'
    -   To return to the homepage click the icon with 4 squares on the left nav-bar and select home

## Import Grafana Dashboards

See the [Import Dashboards](Grafana#import-dashboards)
section to import the unifi-poller dashboards into Grafana. You just need the InfluxDB dashboards
if you followed this how-to.

You should see you first dashboard with data (depending on how long you took to do this how-to!)

Congratulations!

### TODO

-   Verify clean really works ok for all 3 containers
-   case on names (Synology, Grafana, etc is inconsistent)
-   table of contents with active links
-   consider splitting into several pages
-   no one has yet tested method 2 for Grafana - leave it in doc because
    everyone asks 'why can't you use `--run` like Grafana says to'
