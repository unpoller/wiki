## History

I'll keep this brief because it's probably not why you're here. UnFi Poller versions
prior to 2.0 used a single data structure for the config file and environment
variables. This was simple, but not scalable. Versions 2.0 and beyond now have 1
data structure per included go package (core + plugins). Now that the `unifi` plugin
supports multiple controllers it uses a slice (a list in Go) to hold configured
controllers. This changes, considerably, how the environment variables are setup.

The following information only applies to versions 2.0+

## Quick Start

If you just want to get a docker container up and running you really only need a few
config options set. The following four options are typically enough to get going:

```shell
UP_UNIFI_DEFAULT_URL="https://your.unifi.controller.ip:8443"
UP_UNIFI_DEFAULT_USER="unifipoller"
UP_UNIFI_DEFAULT_PASS="unifipoller"
UP_INFLUXDB_URL="http://your.influxdb.ip:8086"
```

In the config file it looks like this:

```toml
[unifi.defaults]
  url  = "https://your.unifi.controller.ip:8443"
  user = "unifipoller"
  pass = "unifipoller"
[influxdb]
  url  = "http://your.influxdb.ip:8086"
```

If you're using Prometheus, you may omit the `[influxdb]` section, or disable it:
`UP_INFLUXDB_DISABLE=true`

## Config File and Environment Variables

The configuration file is broken up into sections. In TOML format, each section begins
with a section `[header]`. List items begin with `[[header]]` and maps use the
format `[header.name]` where `name` is the map key. There may not be any map values
in the config at this time.

You can use any of these formats for the config file: XML, TOML, YAML or JSON.
Examples are provided in the [examples/](../../tree/master/examples) folder.
Use the examples for an explanation of how to structure the config files.
You may pass a blank config file, but you must provide _something_. You can
completely configure the application with environment variables too. Explained below.

-   _IMPORTANT_: **See [up.conf.example](../../tree/master/examples/up.conf.example)
    for a thorough description of each configuration option shown below.**

### Poller (Core)

The poller section begins with the `[poller]` header and has the parameters below.
These control overall behavior of the application.

| ENV | config | type - default | explanation |
| --- | --- | --- | --- |
| UP_POLLER_DEBUG | debug | boolean - `false` | turns on debug messages |
| UP_POLLER_QUIET | quiet | boolean - `false` | turns off timer messages |
| UP_POLLER_PLUGINS_0 | plugins | file list - empty | _advanced!_ plugin file, use `_1`, `_2`, etc to add more |

### Input: UniFi

The unifi section begins with the `[unifi]` header and has the following parameters:

| ENV | config | default, explanation |
| --- | --- | --- |
| UP_UNIFI_DISABLE | disable | `false`, turns off this input. don't do that! |
| UP_UNIFI_DYNAMIC | dynamic | `false`, enables dynamic lookups (from prometheus) |
| UP_UNIFI_DEFAULT_ROLE | unifi.defaults.role | `URL`, allows grouping controllers |
| UP_UNIFI_DEFAULT_URL | unifi.defaults.url | `"https://127.0.0.1:8443"`, only applies if no controllers are defined (next section) |
| UP_UNIFI_DEFAULT_USER | unifi.defaults.user | `"unifipoller"`, default applies to any controller without a username |
| UP_UNIFI_DEFAULT_PASS | unifi.defaults.pass | `""`, default applies to any controller without a password |
| UP_UNIFI_DEFAULT_SAVE_SITES | unifi.defaults.save_sites | `true` |
| UP_UNIFI_DEFAULT_SAVE_EVENTS | unifi.defaults.save_events | `false`, Only works with InfluxDB, added in v2.0.2 |
| UP_UNIFI_DEFAULT_SAVE_IDS | unifi.defaults.save_ids | `false`, Only works with InfluxDB |
| UP_UNIFI_DEFAULT_SAVE_DPI | unifi.defaults.save_dpi | `false` |
| UP_UNIFI_DEFAULT_VERIFY_SSL | unifi.defaults.verify_ssl | `false` |
| UP_UNIFI_DEFAULT_SITE_0 | unifi.defaults.site.0 | `["all"]`, specify more sites with `_1`, `_2`, etc. |

#### UniFi Controllers

You can configure a single controller by setting the `UP_UNIFI_DEFAULT` variables above, but you can also
configure a single, or multiple controllers by setting the variables below.
These, like most, are optional.

You may repeat the `[[unifi.controller]]` section as many times as you want to add more controllers.
If you're configuring controllers using env variables, start at `_0` and change `_0` to `_1` to add a
second, then `_2` and so on.

Like any configured list, you may configure controllers with a file or env vars, or both.

| ENV | config | default, explanation |
| --- | --- | --- |
| UP_UNIFI_CONTROLLER_0_ROLE | unifi.controller.role | `URL`, allows grouping controllers, default applies to any controller without a role |
| UP_UNIFI_CONTROLLER_0_URL | unifi.controller.url | `"https://127.0.0.1:8443"` |
| UP_UNIFI_CONTROLLER_0_USER | unifi.controller.user | `"unifipoller"` |
| UP_UNIFI_CONTROLLER_0_PASS | unifi.controller.pass | `""` |
| UP_UNIFI_CONTROLLER_0_SAVE_SITES | unifi.controller.save_sites | `true`, Powers Network Sites dashboard |
| UP_UNIFI_CONTROLLER_0_SAVE_EVENTS | unifi.controller.save_events | `false`, Only works with InfluxDB, added in v2.0.2 |
| UP_UNIFI_CONTROLLER_0_SAVE_IDS | unifi.controller.save_ids | `false`, Only works with InfluxDB |
| UP_UNIFI_CONTROLLER_0_SAVE_DPI | unifi.controller.save_dpi | `false`, Powers DPI dashboard |
| UP_UNIFI_CONTROLLER_0_VERIFY_SSL | unifi.controller.verify_ssl | `false`, Verify controller SSL certificate |
| UP_UNIFI_CONTROLLER_0_SITE_0 | unifi.controller.site.0 | `["all"]`, specify more sites with `_1`, `_2`, etc. |

### Output: Prometheus

This section begins with `[prometheus]` and configures an HTTP listener where a scrape
daemon, such as Prometheus may obtain metrics. See the [Prometheus](Prometheus) wiki page for
Prometheus configuration instructions.

While Prometheus provides some configuration parameters, **you shouldn't change them.**
If you don't use Prometheus, set `disable` to `true`.
If you do use Prometheus, don't let the parameters temp you.

| ENV | config | default |
| --- | --- | --- |
| UP_PROMETHEUS_DISABLE | prometheus.disable | `false` |
| UP_PROMETHEUS_NAMESPACE | prometheus.namespace | `unifipoller` |
| UP_PROMETHEUS_HTTP_LISTEN | prometheus.http_listen | `0.0.0.0:9130` |
| UP_PROMETHEUS_REPORT_ERRORS | prometheus.report_errors | `false` |
| UP_PROMETHEUS_BUFFER | prometheus.buffer | `50` |

### Output: InfluxDB

This section begins with `[influxdb]` and configures a single influxdb output destination.

| ENV | config | default | explanation |
| --- | --- | --- | --- |
| UP_INFLUXDB_URL | influxdb.url | `"http://127.0.0.1:8086"` | influxdb URL |
| UP_INFLUXDB_DB | influxdb.db | `"unifi"` | name of database you created in influx |
| UP_INFLUXDB_USER | influxdb.user | `"unifipoller"` | username with access to database |
| UP_INFLUXDB_PASS | influxdb.pass | `"unifipoller"` | password for username |
| UP_INFLUXDB_INTERVAL | influxdb.interval | `"30s"` | how often to poll and collect metrics, ie `"1m"` or `"90s"` |
