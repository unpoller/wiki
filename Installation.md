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
wget https://github.com/davidnewhall/unifi-poller/releases/download/v1.3.3/unifi-poller-1.3.3-184.x86_64.rpm
sudo rpm -Uvh unifi-poller*.rpm
```

Debian and Ubuntu variants should download and install the deb with something like this:
```shell
wget https://github.com/davidnewhall/unifi-poller/releases/download/v1.3.3/unifi-poller-1.3.3-184_amd64.deb
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
```
$ brew install unifi-poller
==> Installing unifi-poller from golift/mugs
==> Installing dependencies for golift/mugs/unifi-poller: go and dep
==> Installing golift/mugs/unifi-poller dependency: go
==> Downloading https://homebrew.bintray.com/bottles/go-1.12.6.sierra.bottle.tar.gz
==> Downloading from https://akamai.bintray.com/25/253cd5e8f6989e721a8c2982b4159e6fcd50ad73c0b4b4d036df569e57928093?__gda__=exp=1560924489~hmac=77ca6eeb4568344dbf4dad9f8bc4884347ae4978e4c6a4550be0bb41a8a795bd&response-content-disposition=attachment%3Bfilename%3D%22go-1.12.6.sierra.bottle.tar.gz%22&respon
######################################################################## 100.0%
==> Pouring go-1.12.6.sierra.bottle.tar.gz
🍺  /usr/local/Cellar/go/1.12.6: 9,812 files, 452.7MB
==> Installing golift/mugs/unifi-poller dependency: dep
==> Downloading https://homebrew.bintray.com/bottles/dep-0.5.4.sierra.bottle.tar.gz
==> Downloading from https://akamai.bintray.com/ef/ef9a0a978cbf2d4e537d21c4ff7b89a75b66228697b0aa348daa2284bc7362a9?__gda__=exp=1560924549~hmac=6b643c2179d01564233d3ab9943c4712d0b8eaf6675fb95d6373d88c106716d0&response-content-disposition=attachment%3Bfilename%3D%22dep-0.5.4.sierra.bottle.tar.gz%22&respon
######################################################################## 100.0%
==> Pouring dep-0.5.4.sierra.bottle.tar.gz
🍺  /usr/local/Cellar/dep/0.5.4: 7 files, 11.6MB
==> Installing golift/mugs/unifi-poller
==> Downloading https://github.com/davidnewhall/unifi-poller/archive/v1.3.2.tar.gz
==> Downloading from https://codeload.github.com/davidnewhall/unifi-poller/tar.gz/v1.3.3
######################################################################## 100.0%
==> dep ensure
==> make install VERSION=1.3.3 PREFIX=/usr/local/Cellar/unifi-poller/1.3.3 ETC=/usr/local/etc
==> touch /usr/local/var/log/unifi-poller.log
==> Caveats
  This application will not work until the config file has authentication
  information for a Unifi Controller and an Influx Database. Edit the config
  file at /usr/local/etc/unifi-poller/up.conf then start the application with
  brew services start unifi-poller ~ log file: /usr/local/var/log/unifi-poller.log
  The manual explains the config file options: man unifi-poller

To have launchd start golift/mugs/unifi-poller now and restart at login:
  brew services start golift/mugs/unifi-poller
==> Summary
🍺  /usr/local/Cellar/unifi-poller/1.3.3: 19 files, 8.0MB, built in 16 seconds
```
- Edit the config file after installing the brew:
    ```shell
    nano /usr/local/etc/unifi-poller/up.conf
    # or
    vi /usr/local/etc/unifi-poller/up.conf
    ```
    Correct the authentication information for your setup (see prerequisites).
- Start the service:
    ```shell
    # do not use sudo
    brew services start unifi-poller
    ```
    The **log file** should show up at `/usr/local/var/log/unifi-poller.log`. If it does not show up, make sure your user has permissions to create the file.

- This is how you restart it. **Do this when you upgrade.**:
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