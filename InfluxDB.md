This page provides simple instructions on how to install and maintain InfluxDB.

# Linux

These directions came [from here](https://github.com/davidnewhall/unifi-poller/issues/26).

Install: 
```
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

- Install: `brew install influxdb`
- Start: `brew services start influxdb`

# InfluxDB

These commands work on Linux or macOS.

- Access command: `influx`

Delete database. Do this when the db is too large, or when `unifi-poller` changes a metric type to another type.
```
DROP DATABASE unifi
```

Create database:
```
CREATE DATABASE unifi
CREATE USER unifi WITH PASSWORD 'unifi' WITH ALL PRIVILEGES
GRANT ALL ON unifi TO unifi
```