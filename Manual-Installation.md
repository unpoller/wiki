## Unifi-Poller Manual Installation

This procedure details manual installation, building the software from scratch and installing to /usr/local.
This is not recommended. **Recommended: You should download or [build a package](Installation)
for your operating system, and use that instead of this procedure.**

1.  [Install Go](https://golang.org/doc/install).
1.  **Clone this repo** and change your working directory to the checkout.

     ```shell
     git clone git@github.com:unifi-poller/unifi-poller.git
     cd unifi-poller
     ```
1.  **Compile the app** by typing `make`
    1.  If that gave you no errors, then make the man file `make man`
    1.  If that didn't work, make sure your Go env is up to snuff. I tested this with 1.10 through 1.13.5.
1.  Copy all the files into place.

    **Linux**, as root:

    ```shell
    cp unifi-poller /usr/bin
    mkdir /etc/unifi-poller
    cp examples/up.conf.example /etc/unifi-poller/up.conf
    cp init/systemd/unifi-poller.service /etc/systemd/system
    cp unifi-poller.1.gz /usr/share/man/man1
    ```

    **macOS**:

    ```shell
    cp unifi-poller /usr/local/bin
    mkdir /usr/local/etc/unifi-poller /usr/local/var/log
    cp examples/up.conf.example /usr/local/etc/unifi-poller/up.conf
    cp init/launchd/com.github.unifi-poller.unifi-poller.plist ~/Library/LaunchAgents/
    cp unifi-poller.1.gz /usr/local/share/man/man1
    ```

1.  **Add a user to the Unifi Controller**. After logging in:
    1.  Go to `Settings -> Admins`
    1.  Add a read-only user (`influxdb`) with a nice long password.
1.  Edit `/usr/local/etc/unifi-poller/up.conf` (Mac) `/etc/unifi-poller/up.conf` (Linux)
    1.  Correct the InfluxDB and Unifi Controller authentication settings.
1.  **Create a database in InfluxDB.**  Something like:

    ```shell
    influx -host localhost -port 8086
    CREATE DATABASE unifi
    ```

1.  **Restart the `unifi-poller` service**:

    **macOS**:

    ```shell
    launchctl unload ~/Library/LaunchAgents/com.github.unifi-poller.unifi-poller.plist
    launchctl load -w ~/Library/LaunchAgents/com.github.unifi-poller.unifi-poller.plist
    ```

    **Linux**:

    ```shell
    systemctl daemon-reload
    systemctl start unifi-poller
    ```

1.  **Check the log.** Watch it for a minute or so, look for errors.
    1.  macOS: `/usr/local/var/log/unifi-poller.log`
    1.  Linux: `/var/log/syslog` or `/var/log/messages`.
1.  **If you see errors in the log file:**
    1.  Put it in Debug mode. Edit the config file and restart.
1.  **Add the unifi InfluxDB** database as a [data source to Grafana](https://grafana.com/docs/features/datasources/influxdb/).
1.  **Import the grafana json files** from this repo as dashboards.
1.  Recommend leaving the dashboard as-is, and creating your own with data you care about.
    Dashboards are updated when new metrics are added.

**Good luck!** Please [leave feedback](https://github.com/unifi-poller/unifi-poller/issues/new) about your
experience and how these directions can be improved to save the next person some time. Thanks!

## Installing on Ubuntu tested with 18.04

This is a tl;dr version of the above instructions provided by the community.
These directions manually build and compile unifi-poller, create and install a
package that enables, auto-starts and keeps the application running.

```shell
# Install rubygems, go, fpm.
sudo apt-get install -y ruby golang ruby-dev
sudo gem install --no-document fpm

# Make a go build environment.
cd ~
mkdir ~/go
mkdir ~/go/pkg
mkdir ~/go/pkg/mod
mkdir ~/go/bin
export GOPATH=~/go

# Clone the repo into a "normal" go path.
mkdir -p ~/go/src/github.com/unifi-poller
cd ~/go/src/github.com/unifi-poller
git clone https://github.com/unifi-poller/unifi-poller
cd unifi-poller

# Make and install package.
make deb
sudo dpkg -i unifi-poller*.deb

# Edit config and fix influx and unifi auth details.
sudo vi /etc/unifi-poller/up.conf

# Restart the app after fixing config.
sudo systemctl restart unifi-poller

# Check log file.
tail -f -n30 /var/log/syslog | grep unifi-poller
```
