## Upgrading

See [Updating](Updating) for upgrade details.

## Prerequisites

You need to create an Influx database, or setup Prometheus, and user/pass on the UniFi Controller.
You also need Grafana and you have to add the Influx or Prometheus data source to Grafana.
**Do not skip any of these pre-reqs!**

1.  **Add a user to the UniFi Controller**. After logging into your controller:
    1.  Go to `Settings -> Admins`
    1.  Add a read-only user (`unifipoller`) with a nice long password.
    1.  The new user needs access to each site. For each UniFi Site you want to poll,
        add admin via the 'Invite existing admin' option.
    1.  Take note of this info, you need to put it into the unifi-poller config file in a moment.

1.  **You need [InfluxDB](InfluxDB)** OR **You need Prometheus**.
    -   If you already have one of these, skip ahead to Grafana.
    -   _Using Docker_? You can use the
        [docker-compose file](https://github.com/unifi-poller/unifi-poller/blob/master/init/docker/docker-compose.yml)
        file to setup Poller, InfluxDB and Grafana all at once.
1.  If using Influx, **Create a database in InfluxDB.** Something like:

    ```shell
    influx -host localhost -port 8086
    CREATE DATABASE unifi
    CREATE USER unifipoller WITH PASSWORD 'unifipoller' WITH ALL PRIVILEGES
    GRANT ALL ON unifi TO unifi
    ```

    Take note of the username and password you create (if you choose to do so,
      you may skip the last 2 commands). You'll need the **hostname**, **port**,
      **database name**, and optionally **user/pass** in a moment for the unifi-poller
      config file.

1.  If you're using Prometheus, see the [Prometheus](Prometheus) doc for post-install configuration.
1.  **You need [Grafana](Grafana)**.
    After you follow the directions in [Grafana Wiki](Grafana), and before (or after) you install unifi-poller:
    -   [Add a new data source](https://grafana.com/docs/features/datasources/influxdb/)
        for the InfluxDB `unifi` database you created.
    -   Or, if you use Prometheus, add a [Prometheus data source](https://grafana.com/docs/features/datasources/prometheus/).
    -   **Do not forget to add the data source!** It's generally just a URL, very easy.

## Docker

-   Check that you meet the pre-reqs above, or use
    [Docker Compose](https://github.com/unifi-poller/unifi-poller/blob/master/init/docker/docker-compose.yml)
    to "do it all."
-   See [Docker](Docker) for information about installing unifi-poller.
-   Then see the [Configuration](Configuration) doc for post-install configuration information.
-   _Synology_? Check out the [Synology HOWTO](Synology-HOWTO) provided by @Scyto.

## FreeBSD

-   Download a `txz` package from the [Releases](https://github.com/unifi-poller/unifi-poller/releases) page.
-   Install it, and use these commands to maintain the service:

```shell
# Install package.
pkg install unifi-poller-2.0.0-800.amd64.txz
# View manual.
man unifi-poller

# Start, Restart, Stop service.
service unifi-poller start
service unifi-poller restart
service unifi-poller stop
# Check service status, useful for scripts.
service unifi-poller status

# Logs should wind up in this file, but your syslog may differ.
grep unifi-poller /var/log/messages
```

Sorry I don't use FreeBSD so I have very few tips for this OS.
Free to [update the wiki](https://github.com/unifi-poller/wiki/blob/master/README.md)!

## Linux

JFrog Bintray provides package hosting for RedHat/CentOS/Debian/Ubuntu repos.
The same package is in all the repos, but you can set the name to match your OS
as shown below.

### RedHat variants (CentOS)

-   Create a file at `/etc/yum.repos.d/golift.repo` with the following contents.
-   You may replace `centos` with `el`, but they're the same thing either way.

```yaml
[golift]
name=Go Lift Awesomeness - Main Repo
baseurl=https://dl.bintray.com/golift/centos/main/$basearch/
gpgcheck=1
repo_gpgcheck=1
enabled=1
sslverify=1
gpgkey=https://golift.io/gpgkey
```

-   Then install the package: `sudo yum install unifi-poller`
-   You'll have to respond `yes` to the prompts to install the Go Lift GPG key.

### Debian variants (Ubuntu)

-   Install the repo and package using the commands below.
-   Replace `ubuntu` with `debian` if you have Debian.
-   Supported distributions:
    -   `xenial`, `bionic`, `focal`, `jesse`, `stretch`, `buster`, `bullseye`
    -   If you have another distro, try one of these ^  (they're all the same).

```shell
curl -s https://golift.io/gpgkey | sudo apt-key add -
echo deb https://dl.bintray.com/golift/ubuntu bionic main | sudo tee /etc/apt/sources.list.d/golift.list
sudo apt update
sudo apt install unifi-poller
```

### Linux: Post-Install

See the [Configuration](Configuration) doc and the
[example config file](https://github.com/unifi-poller/unifi-poller/blob/master/examples/up.conf.example)
for additional post-install configuration information.

-   Edit the config file after installing the package, and
    correct the authentication information for your setup:

    ```shell
    sudo nano /etc/unifi-poller/up.conf
    # or
    sudo vi /etc/unifi-poller/up.conf
    ```

-   Restart the service:

    ```shell
    sudo systemctl restart unifi-poller
    ```

-   Check the log:

    ```shell
    tail -f -n100  /var/log/syslog /var/log/messages | grep unifi-poller
    ```

## macOS

Use Homebrew.

1.  [Install Homebrew](https://brew.sh/)
1.  `brew install golift/mugs/unifi-poller`
1.  Edit the config file after installing the brew:

    ```shell
    nano /usr/local/etc/unifi-poller/up.conf
    # or
    vi /usr/local/etc/unifi-poller/up.conf
    ```

    Correct the authentication information for your setup (see prerequisites).

1.  Start the service:

    ```shell
    # do not use sudo
    brew services start unifi-poller
    ```

    The **log file** should show up at `/usr/local/var/log/unifi-poller.log`.
    If it does not show up, make sure your user has permissions to create the file.

1.  This is how you restart it. **Do this when you upgrade.**:

    ```shell
    brew services restart unifi-poller
    ```

## Manual Package

You can build your own package from source with the `Makefile`.
Recommend reading the note at the bottom if you're using a mac.

1.  [Install FPM](https://fpm.readthedocs.io/en/latest/installing.html)
1.  [Install Go](https://golang.org/doc/install).
1.  **Clone this repo** and change your working directory to the checkout.

    ```shell
    git clone https://github.com/unifi-poller/unifi-poller.git
    cd unifi-poller
    ```

1.  **Install local Golang dependencies**:
1.  Build a package (or two!):
    1.  `make deb` will build a Debian package.
    1.  `make rpm` builds a RHEL package.
1.  Install it:
    1.  `sudo dpkg -i *.deb || sudo rpm -Uvh *.rpm`

### Manual Build Notes

If you're building linux packages on a mac you can run `brew install rpmbuild gnu-tar`
to get the additional tools you need. That means you're going to need [Homebrew](https://brew.sh).
And if you're going to install Homebrew, or already have, you can simply do something
like this to get your Go environment up and build the packages:

```shell
brew install rpmbuild gnu-tar go dep
sudo gem install --no-document fpm
mkdir ~/go/{src,mod}
export GOPATH=~/go
cd ~go/src
git clone https://github.com/unifi-poller/unifi-poller.git
cd unifi-poller
make rpm deb
```
