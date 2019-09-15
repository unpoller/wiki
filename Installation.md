Architecture-specific packages are available for Debian/Ubuntu, RedHat/Fedora and macOS. Beginning with version 1.3.0 homebrew installation is available for macOS, and the pkg for macOS has been removed as of version 1.3.1 (the launchd config is unreliable). The packages (or brew) allow you to install a prebuilt binary, config file and startup script (systemd or launchd) without knowing anything about Go or compiling applications. Pre-built packages are available on the [Releases](https://github.com/davidnewhall/unifi-poller/releases) page.

**If you already ran `make install` you need to run `make uninstall` before switching the install to a package (or brew).**

# Prerequisites

You need to create an Influx database and user/pass on the UniFi Controller. 

1. **Add a user to the UniFi Controller**. After logging into your controller:
   1. Go to `Settings -> Admins`
   1. Add a read-only user (`influx`) with a nice long password. 
   1. The new user needs access to each site. For each UniFi Site you want to poll, add admin via the 'Invite existing admin' option.
   1. Take note of this info, you need to put it into the unifi-poller config file in a moment.
1. **You need [InfluxDB](InfluxDB)**. If you already have this, skip ahead.
1. **Create a database in InfluxDB.**
   1. Something like:
     ```shell
     influx -host localhost -port 8086
     CREATE DATABASE unifi
     CREATE USER unifi WITH PASSWORD 'unifi' WITH ALL PRIVILEGES
     GRANT ALL ON unifi TO unifi
     ```
     Take note of the username and password you create (if you choose to do so, you may skip the last 2 commands). You'll need the **hostname**, **port**, **database name**, and optionally **user/pass** in a moment for the unifi-poller config file.
1. **You need [Grafana](Grafana)**. 
    After you follow the directions in [Grafana Wiki](Grafana):
    1. [Add a new data source](https://grafana.com/docs/features/datasources/influxdb/) for the InfluxDB `unifi` database you created.
    1. Don't forget to **Install Grafana Plugins** and **[Dashboards](Grafana-Dashboards)**. You must create the data source before importing the dashboards.

# Docker

Check that you meet the pre-reqs. Then see [Docker](Docker).
If you are running docker on a Synology consider using the [HOWTO](https://github.com/davidnewhall/unifi-poller/wiki/Synology-HOWTO) doc.

# Linux

**Find the latest version on the [Releases](https://github.com/davidnewhall/unifi-poller/releases) page.**

Use the provided [install.sh script](https://github.com/davidnewhall/unifi-poller/blob/master/scripts/install.sh) to download (and optionally install) the correct package for your system. Running with `sudo` is optional and will invoke `rpm` or `dpkg` to install the downloaded package.
```shell
curl https://raw.githubusercontent.com/davidnewhall/unifi-poller/master/scripts/install.sh | sudo bash
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

You can build your own package from source with the `Makefile`. Recommend reading the note at the bottom if you're using a mac.

1. [Install FPM](https://fpm.readthedocs.io/en/latest/installing.html)
1. [Install Go](https://golang.org/doc/install). 
1. [Install dep](https://golang.github.io/dep/docs/installation.html).
1. **Clone this repo** and change your working directory to the checkout.
   ```shell
   git clone https://github.com/davidnewhall/unifi-poller.git
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

### Note

If you're building linux packages on a mac you can run `brew install rpmbuild gnu-tar` to get the additional tools you need. That means you're going to need [Homebrew](https://brew.sh). And if you're going to install Homebrew, or already have, you can simply do something like this to get your Go environment up and build the packages:
```shell
brew install rpmbuild gnu-tar go dep
sudo gem install --no-document fpm
mkdir ~/go/{src,mod}
export GOPATH=~/go
cd ~go/src
git clone https://github.com/davidnewhall/unifi-poller.git
cd unifi-poller
dep ensure
make rpm deb
```