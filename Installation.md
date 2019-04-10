# Unifi-Poller Installation

1. [Install Go](https://golang.org/doc/install). 
1. [Install dep](https://golang.github.io/dep/docs/installation.html).
1. [Install Ronn](Ronn). This makes a man page so you can run `man unifi-poller`.
1. **Clone this repo** and change your working directory to the checkout.
   ```shell
   git clone git@github.com:davidnewhall/unifi-poller.git
   cd unifi-poller
   ```
1. **Install local Golang dependencies**: 
   ```shell
   dep ensure -update
   ```
1. **Compile the app** by typing `make`
   1. If that gave you no errors, then proceed.
   1. If that didn't work, make sure your Go env is up to snuff. I tested this with 1.11.4 & 1.12.1
1. **Run `sudo make install` to automatically install the application** and a startup script to keep it running.
   1. This isn't well tested on Linux, so please provide feedback. Open an [Issue](https://github.com/davidnewhall/unifi-poller/issues/new).
   1. This is also a safe operation to re-run when you want to [update](Updating).
1. **Add a user to the Unifi Controller**. After logging in:
    1. Go to `Settings -> Admins`
    1. Add a read-only user (`influxdb`) with a nice long password. 
1. **Edit `/usr/local/etc/unifi-poller/up.conf`**
    1. Correct the InfluxDB and Unifi Controller authentication settings.
1. **Create a database in InfluxDB.**  Something like:
   ```shell
   influx -host localhost -port 8086
   CREATE DATABASE unifi
   ```
1. **Restart the `unifi-poller` service**:
  
      macOS: 
      ```shell
      launchctl unload ~/Library/LaunchAgents/com.github.davidnewhall.unifi-poller.plist
      launchctl load ~/Library/LaunchAgents/com.github.davidnewhall.unifi-poller.plist
      ```
      Linux:
      ```shell
      sudo systemctl restart unifi-poller
      ```
1. **Check the log.** Watch it for a minute or so, look for errors.
   1. macOS: `/usr/local/var/log/unifi-poller.log`
   1. Linux: somewhere in `/var/log` (check `messages` and `syslog`). [Tell me](https://github.com/davidnewhall/unifi-poller/issues/new) where you found it.
1. **If you see errors in the log file:**
   1. Put it in Debug mode. Edit the startup file and add `--debug` to the cli arguments.
   1. macOS: `~/Library/LaunchAgents/com.github.davidnewhall.unifi-poller.plist`
   1. Linux: `/etc/systemd/system/unifi-poller.service`
   1. Restart the service (shown above).
1. **Add the unifi InfluxDB** database as a [data source to Grafana](https://grafana.com/docs/features/datasources/influxdb/). 
1. **Import the grafana json files** from this repo as dashboards.
1. You'll almost certainly have to edit the dashboard because it has a few hard coded things specific to my network.

**Good luck!** Please [leave feedback](https://github.com/davidnewhall/unifi-poller/issues/new) about your experience and how these directions can be improved to save the next person some time. Thanks!

# Auto Start
- Running `make install` (macOS) or `sudo make install` (linux) should put the files in the right place. Then just start the service with one of the commands below. 

If you want to do it yourself, here it is:
- Build it: `go build ./...`
- Copy `up.conf` to `/usr/local/etc/unifi-poller/up.conf`
- Copy/Install the `unifi-poller` binary to `/usr/local/bin/unifi-poller`
- Then:

## macOS: start `unifi-poller` service
- Copy the launch agent plist to `~/Library/LaunchAgents/com.github.davidnewhall.unifi-poller.plist`
- `launchctl load ~/Library/LaunchAgents/com.github.davidnewhall.unifi-poller.plist`

## Linux: start `unifi-poller` service 
- Copy the systemd service unit file to `/etc/systemd/system/unifi-poller.service`
- `sudo systemctl start unifi-poller`