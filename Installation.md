# Unifi-Poller Installation

This will be expanded upon as I take more screenshots and get everything dialed in. Help is always appreciated.

Basically:
- Compile the app by typing `make`.
- If that didn't work, make sure your Go env is up to snuff. I tested this with 1.9 and 1.10.
- Log into your Unifi Controller, Go to `Settings -> Admins` and add a read-only user (`influxdb`) with a nice long password. Try `uuidgen`.
- copy `up.conf.example` to `up.conf`, edit it with your endpoint access details. 
- create a database in influxdb. `CREATE DATABASE unifi`
- run it: `./unifi-poller -c up.conf -D`
- Add the unifi database as a data source to Grafana.
- Import the grafana json file from this repo as a dashboard.
- You'll almost certainly have to edit the dashboard because it has a few hard coded things specific to my network.
- Good luck!

# Auto Start (incomplete, needs launch files added to repo)
- Copy `up.conf` to `/usr/local/etc/unifi-poller/up.conf`
- Copy/Install the `unifi-poller` binary to `/usr/local/bin/unifi-poller`

## macOS
- Copy the launch agent plist to `~/Library/LaunchAgents/pro.sleepers.unifi-poller.plist`
- `launchctl load ~/Library/LaunchAgents/pro.sleepers.unifi-poller.plist`

## Linux
- Copy the systemd service unit file to `/etc/systemd/system/unifi-poller.service`
- `sudo systemctl start unifi-poller`