[DO NOT FOLLOW THESE INSTRUCTIONS THEY ARE UNDER CONSTRUCTION]

# Introduction
Assumptions:
1. You already installed docker from package center
2. You already enabled SSH on your synology <insert link to SSH instructions elsewhere>
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
1. Create the following structure in your preferred location (mine is a shared folder called docker) <note i am not sure which you absolutely need to precreate might be good to test - hmm thje structure below does not render correctly>
/Docker
  |-grafana
      |-home
      |-provisioning
      |-config
      |-plugins
      |-data
  |-influxdb
      |-data
      |-wal
      |-meta
  |-unifipoller

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


[DO NOT FOLLOW THESE INSTRUCTIONS THEY ARE UNDER CONSTRUCTION]
