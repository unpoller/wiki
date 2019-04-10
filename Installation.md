# Unifi-Poller Installation

This will be expanded upon as I take more screenshots and get everything dialed in. Help is always appreciated.

Basically:
1. [Install Go](https://golang.org/doc/install). 
1. [Install dep](https://golang.github.io/dep/docs/installation.html).
1. [Install Ronn](Ronn). This makes a man page so you can run `man unifi-poller`
1. Clone this repo and change your working directory to the checkout.
   1. `git clone git@github.com:davidnewhall/unifi-poller.git ; cd unifi-poller`
1. Install local Golang dependencies: 
   1. `dep init`
   1. `dep ensure -update`
1. Compile the app by typing `make`.
   1. If that gave you no errors, then proceed.
   1. If that didn't work, make sure your Go env is up to snuff. I tested this with 1.11.4 & 1.12.1
1. Run `sudo make install` to automatically install the application and a startup script to keep it running.
   1. This isn't well tested on Linux, so please provide feedback. Open an [Issue](https://github.com/davidnewhall/unifi-poller/issues/new).
   1. This is also a safe operation to re-run when you want to [update](Updating).
1. Log into your Unifi Controller, Go to `Settings -> Admins` and add a read-only user (`influxdb`) with a nice long password. Try `uuidgen`.
1. Edit `/usr/local/etc/unifi-poller/up.conf` - Correct the influxdb configuration.
1. Create a database in influxdb. `CREATE DATABASE unifi`
1. Restart the service:
   1. mac: 
      ```shell
      launchctl unload ~/Library/LaunchAgents/com.github.davidnewhall.unifi-poller.plist
      launchctl load ~/Library/LaunchAgents/com.github.davidnewhall.unifi-poller.plist
      ```
   1. linux
      ```shell
      sudo systemctl restart unifi-poller
      ```
1. Check the log. mac: `/usr/local/var/log/unifi-poller.log` linux: somewhere in `/var/log` (check `messages` and `syslog`). [Tell me](https://github.com/davidnewhall/unifi-poller/issues/new) where you found it.
1. Add the unifi InfluxDB database as a [data source to Grafana](https://grafana.com/docs/features/datasources/influxdb/). 
1. Import the grafana json files from this repo as dashboards.
1. You'll almost certainly have to edit the dashboard because it has a few hard coded things specific to my network.

**Good luck!** Please [leave feedback](https://github.com/davidnewhall/unifi-poller/issues/new) about your experience and how these directions can be improved to save the next person some time. Thanks!

# Auto Start
- Running `make install` (macOS) or `sudo make install` (linux) should put the files in the right place. Then just start the service with one of the commands below. 

If you want to do it yourself, here it is:
- Build it: `go build ./...`
- Copy `up.conf` to `/usr/local/etc/unifi-poller/up.conf`
- Copy/Install the `unifi-poller` binary to `/usr/local/bin/unifi-poller`
- Then:

## macOS
- Copy the launch agent plist to `~/Library/LaunchAgents/com.github.davidnewhall.unifi-poller.plist`
- `launchctl load ~/Library/LaunchAgents/com.github.davidnewhall.unifi-poller.plist`

## Linux
- Copy the systemd service unit file to `/etc/systemd/system/unifi-poller.service`
- `sudo systemctl start unifi-poller`