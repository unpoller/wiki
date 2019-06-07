# Unifi-Poller Manual Installation

This procedure details manual installation, building the software from scratch and installing to /usr/local. **Recommended: You may be able to download or build a package for your operating system, and use that instead of this procedure.**

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
   dep ensure
   ```
   Note: Running `dep ensure` with the `-update` flag may pull in dependencies with compatibility problems.

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

# Installing on Ubuntu tested with 18.04
These directions manually build and compile unifi-poller. The `make install` command enables and starts the systemd service unit. Remember to update the configuration file and restart the service with `systemctl`. Commands without sudo do not have to be run as root, but this entire process works as root too.
 
```shell
# All this hoopla for a man page, but it's worth it.
sudo apt-get install -y ruby golang ruby-dev
sudo gem install --no-document ronn

# OPTIONAL, install fpm to build a package. Install this instead of manual install. (more later)
sudo gem install --no-document fpm

# Make a build environment.
cd ~
mkdir ~/go
mkdir ~/go/pkg
mkdir ~/go/pkg/mod
mkdir ~/go/bin
export GOPATH=~/go

# Clone the repo into a "normal" go path.
mkdir -p ~/go/src/github.com/davidnewhall
cd ~/go/src/github.com/davidnewhall
git clone https://github.com/davidnewhall/unifi-poller
cd unifi-poller

# Install dependencies.
go get github.com/golift/unifi
go get github.com/influxdata/influxdb1-client/v2
go get github.com/naoina/toml
go get github.com/spf13/pflag
go get github.com/naoina/go-stringutil
go get github.com/pkg/errors

# OPTIONAL: Instead of installing directly to /usr/local you may build a package and install that.
# If you do this, DO NOT run make install. These two commands build, install, enable and start unifi-poller.
make deb
sudo dpkg -i unifi-poller*.deb

# OR, run make install as root - this command builds, installs, enables and starts unifi-poller
sudo make install

# Edit config and fix influx and unifi auth details.
sudo vi /usr/local/etc/unifi-poller/up.conf
# If you install the package, the config file is at /etc/unifi-poller/up.conf

# Restart the app after fixing config.
sudo systemctl restart unifi-poller

# Check log file.
tail -f -n30 /var/log/syslog | grep unifi-poller
```
**Note**: There probably a few more packages to `go get`. Check [Gopkg.lock](https://github.com/davidnewhall/unifi-poller/blob/master/Gopkg.lock) for all the package names.