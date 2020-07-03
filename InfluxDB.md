This page provides simple instructions on how to install and maintain InfluxDB.

Most of the production use of this software is with **InfluxDB 1.7.7** = this version is well tested.
Many users have reported missing data and empty graphs when using versions of InfluxDB prior to 1.7.x.

# Linux

## CentOS 7

Provided by community:
[https://github.com/unifi-poller/unifi-poller/issues/30](https://github.com/unifi-poller/unifi-poller/issues/30)

## CentOS 8 / RHEL 8

Provided by community:
[https://computingforgeeks.com/how-to-install-influxdb-on-rhel-8-centos-8/](https://computingforgeeks.com/how-to-install-influxdb-on-rhel-8-centos-8/)

## Ubuntu 18.04

These directions came [from here](https://github.com/unifi-poller/unifi-poller/issues/26).

Install:

```shell
echo "deb https://repos.influxdata.com/ubuntu bionic stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
sudo apt -y update
sudo apt install -y influxdb
```

Start: `sudo systemctl start influxdb`

# macOS

You need [Homebrew](https://brew.sh/):

```shell
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

```shell
brew install influxdb
brew services restart influxdb
```

# InfluxDB

These commands work on Linux or macOS.

-   Access command: `influx`

Delete database. Do this when the db is too large, or when `unifi-poller` changes a metric type to another type.

```shell
DROP DATABASE unifi
```

You can also get specific and drop certain measurements.

```shell
USE unifi
SHOW measurements
DROP measurement <measurement>
```

Create database:

```shell
influx -host localhost -port 8086
CREATE DATABASE unifi
USE unifi
CREATE USER unifipoller WITH PASSWORD 'unifipoller' WITH ALL PRIVILEGES
GRANT ALL ON unifi TO unifipoller
```
