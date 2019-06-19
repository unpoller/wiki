Beginning with version 1.1.1 architecture-specific packages are available for Debian/Ubuntu, RedHat/Fedora and macOS. Beginning with version 1.3.0 homebrew installation is available for macOS, and the pkg for macOS has been removed as of version 1.3.1 (it was buggy). The packages (or brew) allow you to install a prebuilt binary, config file and startup script (systemd or launchd) without knowing anything about Go. The easy way. Pre-built packages are available on the [Releases](https://github.com/davidnewhall/unifi-poller/releases) page.

**If you already ran `make install` you need to run `make uninstall` before switching the install to a package (or brew).**

# Prerequisites

You need to create an Influx database and user/pass on the Unifi Controller. 

1. **Add a user to the Unifi Controller**. After logging into your controller:
   1. Go to `Settings -> Admins`
   1. Add a read-only user (`influxdb`) with a nice long password. 
   1. Take note of this info, you need to put it into the unifi-poller config file in a moment.
1. **You need [InfluxDB](InfluxDB)**. If you already have this, skip ahead.
1. **Create a database in InfluxDB.**
   1. Something like:
     ```shell
     influx -host localhost -port 8086
     CREATE DATABASE unifi
     ```
   If your InfluxDB requires authentication, then you probably know more about it than I do! Take note of the username and password you create (if you choose to do so, Influx is normally authentication-less). You'll need the **hostname**, **port**, **database name**, and optionally **user/pass** in a moment for the unifi-poller config file.
1. **You need [Grafana](Grafana)**. 
    1. [Add a new data source](https://grafana.com/docs/features/datasources/influxdb/) for the InfluxDB `unifi` database you created.
1. **Install Grafana Plugins**
   1. Click this link, scroll to the bottom, and action the Plugins section:
   1. https://github.com/davidnewhall/unifi-poller/wiki/Grafana#plugins
   1. Forgetting to do this will render most of the dashboards useless and empty.

# Docker
See [Docker](Docker)

# Linux

**Find the latest version on the [Releases](https://github.com/davidnewhall/unifi-poller/releases) page.**

Redhat and Fedora variants should download and install the rpm with something like this:
```shell
wget https://github.com/davidnewhall/unifi-poller/releases/download/v1.3.2/unifi-poller-1.3.2-175.x86_64.rpm
sudo rpm -Uvh unifi-poller*.rpm
```

Debian and Ubuntu variants should download and install the deb with something like this:
```shell
wget https://github.com/davidnewhall/unifi-poller/releases/download/v1.3.2/unifi-poller_1.3.2-175_amd64.deb
sudo dpkg -i unifi-poller*.deb
```

Edit the config file after installing the package:
```shell
sudo nano /etc/unifi-poller/up.conf
# or
sudo vi /etc/unifi-poller/up.conf
```
Correct the authentication information for your setup.

Restart the service:
```shell
sudo systemctl restart unifi-poller
```

Check the log:
```shell
tail -f -n100  /var/log/syslog /var/log/messages | grep unifi-poller
```

# macOS

Use Homebrew.

1. [Install Homebrew](https://brew.sh/)
1. `brew tap golift/mugs`
1. `brew install unifi-poller`
1. Edit the config file after installing the brew:
    ```shell
    nano /usr/local/etc/unifi-poller/up.conf
    # or
    vi /usr/local/etc/unifi-poller/up.conf
    ```
    Correct the authentication information for your setup (see prerequisites).
1. Start the service:
    ```shell
    # do not use sudo
    brew services start unifi-poller
    ```
    The **log file** should show up at `/usr/local/var/log/unifi-poller/log`. If it does not show up, make sure your user has permissions to create the file.

- If you need to restart it:
    ```shell
    brew services restart unifi-poller
    ```

# Manually

You can build your own package from source with the `Makefile`.

1. [Install FPM](https://fpm.readthedocs.io/en/latest/installing.html)
1. [Install Go](https://golang.org/doc/install). 
1. [Install dep](https://golang.github.io/dep/docs/installation.html).
1. **Clone this repo** and change your working directory to the checkout.
   ```shell
   git clone git@github.com:davidnewhall/unifi-poller.git
   cd unifi-poller
   ```
1. **Install local Golang dependencies**: 
   ```shell
   dep ensure
   ```
1. Build a package (or two!): 
   1. `make deb` will build a Debian package.
   1. `make rpm` builds a RHEL package.
1. Install it:
   1. `sudo dpkg -i *.deb || sudo rpm -Uvh *.rpm`

Note: If you're building linux packages on a mac you can run `brew install rpmbuild gnu-tar` to get the additional tools you need. That means you're going to need [Homebrew](https://brew.sh).