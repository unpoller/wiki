# Unifi-Poller Installation

This will be expanded upon as I take more screenshots and get everything dialed in. Help is always appreciated.

Basically:
- [Install Go](https://golang.org/doc/install). 
- [Install dep](https://golang.github.io/dep/docs/installation.html).
- Clone this repo. Change your working directory to the checkout.
  - `git clone git@github.com:davidnewhall/unifi-poller.git ; cd unifi-poller`
- Install local dependencies by typing `make dep`
- Compile the app by typing `make`.
- If that gave you no errors, then proceed.
- If that didn't work, make sure your Go env is up to snuff. I tested this with 1.11.4 & 1.12.1
- Run `sudo make install` to automatically install the application and a startup script to keep it running.
  - This isn't well tested on Linux, so please provide feedback. Open an [Issue](https://github.com/davidnewhall/unifi-poller/issues/new).
- Log into your Unifi Controller, Go to `Settings -> Admins` and add a read-only user (`influxdb`) with a nice long password. Try `uuidgen`.
- Edit `/usr/local/etc/unifi-poller/up.conf` - Correct the influxdb configuration.
- Create a database in influxdb. `CREATE DATABASE unifi`
- Restart the service:
  - mac: 
    - `launchctl unload ~/Library/LaunchAgents/com.github.davidnewhall.unifi-poller.plist`
    - `launchctl load ~/Library/LaunchAgents/com.github.davidnewhall.unifi-poller.plist`
  - linux
    - `sudo service unifi-poller restart`
- Check the log. mac: `/usr/local/var/log/unifi-poller.log` linux: somewhere in `/var/log` (check `messages` and `syslog`)
- Add the unifi database as a data source to Grafana.
- Import the grafana json files from this repo as dashboards.
- You'll almost certainly have to edit the dashboard because it has a few hard coded things specific to my network.
- Good luck!

# Auto Start
- Running `make install` (macOS) or `sudo make install` (linux) should put the files in the right place. Then just start the service with one of the commands below. 

If you want to do it yourself, here it is:
- Copy `up.conf` to `/usr/local/etc/unifi-poller/up.conf`
- Copy/Install the `unifi-poller` binary to `/usr/local/bin/unifi-poller`
- Then:

## macOS
- Copy the launch agent plist to `~/Library/LaunchAgents/com.github.davidnewhall.unifi-poller.plist`
- `launchctl load ~/Library/LaunchAgents/com.github.davidnewhall.unifi-poller.plist`

## Linux
- Copy the systemd service unit file to `/etc/systemd/system/unifi-poller.service`
- `sudo systemctl start unifi-poller`