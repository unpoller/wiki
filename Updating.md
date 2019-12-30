## Upgrading to Version 2

UniFi Poller version 2 changes the config file format and the env variable names.
This section intends to help you upgrade. Also check out the [Configuration](Configuration)
doc for more information on configuration options.

### Config File

If you only have 1 controller you can delete the `[[unifi.controller]]` section
at the bottom of `up.conf`, and configure your controller in the `[unifi.defaults]`
section.

Copy your parameters from your existing config file into the new one. The names have
changed slightly, and each section has a `[header]` that must remain. Use the
[example config file](https://github.com/unifi-poller/unifi-poller/blob/master/examples/up.conf.example)
for reference.

If you don't use Prometheus or InfluxDB, set `disable = true` for the one you don't use.
Leaving Prometheus enabled without using it _safe_ and fine. This exposes a web port
you can scrape metrics from using
[apps that support OpenMetrics format](https://openmetrics.io).

### Docker ENV Variables

The names changed a bit, you can see all the new variables in the [Configuration](Configuration)
doc. Below are the ones you probably used to configured your system.

|v1.x ENV|v2.x ENV|
|---|---|
|UP_DEBUG_MODE|UP_POLLER_DEBUG|
|UP_SAVE_IDS|UP_UNIFI_DEFAULT_SAVE_IDS|
|n/a|UP_UNIFI_DEFAULT_SAVE_DPI|
|UP_VERIFY_SSL|UP_UNIFI_DEFAULT_VERIFY_SSL|
|UP_UNIFI_URL|UP_UNIFI_DEFAULT_URL|
|UP_UNIFI_USER|UP_UNIFI_DEFAULT_USER|
|UP_UNIFI_PASS|UP_UNIFI_DEFAULT_PASS|
|UP_UNIFI_SITES|UP_UNIFI_DEFAULT_SITES_0, UP_UNIFI_DEFAULT_SITES_1, ...|
|UP_INFLUX_URL|UP_INFLUXDB_URL|
|UP_INFLUX_USER|UP_INFLUXDB_USER|
|UP_INFLUX_PASS|UP_INFLUXDB_PASS|
|UP_INFLUX_DB|UP_INFLUXDB_DB|
|UP_POLLING_INTERVAL|UP_INFLUXDB_INTERVAL|
|UP_HTTP_LISTEN|UP_PROMETHEUS_HTTP_LISTEN|

## General Upgrade Advice

**If you installed a package from a repo** (recommended), just run `sudo apt update unifi-poller`
or `sudo yum install unifi-poller`. The package will correctly restart `unifi-poller`
after upgrading and will not overwrite your existing configuration file(s).

**If you installed a package** and `unifi-poller` is working, updating is simple:
[Download](https://github.com/unifi-poller/unifi-poller/releases) and install a new package.
The package will correctly restart `unifi-poller` after upgrading and will not overwrite
your existing configuration file(s). After installing the new package, you may choose to
[import updated dashboards](Grafana#dashboards).

macOS: `brew upgrade unifi-poller`

If you want to build and install a new package:

Go back to your git checkout for unifi-poller, or clone it again.

```shell
git clone git@github.com:unifi-poller/unifi-poller.git
cd unifi-poller
git pull -p
```

Test First (optional)

```shell
make test
```

Build a new package, pick one:

```shell
make deb
make rpm
```

Install the package:

```shell
# redhat/centos/fedora:
rpm -Uvh *.rpm || dpkg -i *.deb
```
