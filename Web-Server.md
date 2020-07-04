Poller has a built-in and **disabled by default** web server. The web server provides some very basic information
about your UniFi environment, devices and clients. At the
time of this writing it is only an API, but a simple human interface (read-only) is planned.

-   The web server was added in UniFi Poller v2.0.2.

# Usage

You must enable the web server if you wish to use it.
To enable the web server without authentication this is all
you need to do.

```toml
[webserver]
  enable = true
```

# Authentication

By default there is no authentication. To enable
authentication, add a username and password.
Like this (`captain` is the username):

```toml
[webserver.accounts]
  username = "password hash goes here"
  captain = "$2a$04$a2XvB0gvTXW6d4rHUXQdduUDBrQB3/2lGTxZXQ32Sd9hYDxrz.oHm"
```

Using an env variable (`captain` is the username):

```shell
UP_WEBSERVER_ACCOUNTS_captain="$2a$04$a2XvB0gvTXW6d4rHUXQdduUDBrQB3/2lGTxZXQ32Sd9hYDxrz.oHm"
```

## Making a Password Hash

Use `unifi-poller` to make a web server account password hash.
Like this:

```shell
unifi-poller -e -
Enter Password:
$2a$04$a2XvB0gvTXW6d4rHUXQdduUDBrQB3/2lGTxZXQ32Sd9hYDxrz.oHm
```

Using Docker:

```shell
docker pull golift/unifi-poller
docker -it golift/unifi-poller -e -
Enter Password:
$2a$04$yOE5zjJs2Gg0jsGQpE7j2ucKiNndUGEzpX6BsLoKl0hkxBvE81z8.
```

# Advanced

These are the advanced settings and their default values.

```toml
  port          = 37288
  html_path     = "/usr/lib/unifi-poller/web"
  ssl_cert_path = ""
  ssl_key_path  = ""
  max_events    = 200
```

The default HTML path is installed by any package or
the Official Golift Docker image. This usually does not
need to be changed. Exception are BSD and macOS. The HTML
path on these OSes is `/usr/local/lib/unifi-poller/web`.

An SSL listener may be enabled instead of standard HTTP
by providing an SSL Cert File and Key File paths.

The `max_events` setting controls memory usage. For small
or home sites you can safely set this to `1000` or higher.
This setting dictates how many logs are kept in memory.
The setting is a global setting that applies to all log queues.
There are several log queues per plugin.

# API

These are the available API paths and what they output.

## `/health`

Prints `OK`.

## `/api/v1/config`

Prints `poller` config.

```shell
$ curl unifi.poller:37288/api/v1/config | jq .
{
  "poller": {
    "plugins": [],
    "debug": true,
    "quiet": false
  },
  "uptime": 4623
}
```

## `/api/v1/plugins`

Prints list of plugins. Output and Input.

```shell
$ curl unifi.poller:37288/api/v1/plugins
{"inputs":["unifi"],"outputs":["WebServer","InfluxDB","Loki","Prometheus"]}
```

## `/api/v1/output/<output>`

Prints configuration for `<output>` output plugin.

```shell
$ curl -s unifi.poller:37288/api/v1/output/Loki | jq .
{
  "disable": false,
  "verify_ssl": false,
  "url": "http://loki:3100",
  "user": "",
  "pass": "false",
  "tenant_id": "",
  "interval": {
    "Duration": 120000000000
  },
  "timeout": {
    "Duration": 10000000000
  }
}
```

## `/api/v1/output/<output>/eventgroups`

Prints all event-groups present for the requested output plugin.
Output plugins currently only have one event group but there
is nothing limiting them from adding more.

```shell
$ curl -s unifi.poller:37288/api/v1/output/Loki/eventgroups
["Loki"]

$ curl -s unifi.poller:37288/api/v1/output/Prometheus/eventgroups
["Prometheus"]

$ curl -s unifi.poller:37288/api/v1/output/WebServer/eventgroups
["WebServer"]

$ curl -s unifi.poller:37288/api/v1/output/InfluxDB/eventgroups
["InfluxDB"]
```

## `/api/v1/output/<output>/events/<group>`

Prints events specific to the requested output and group.
Looks like output plugin events with one less dictionary.

## `/api/v1/output/<output>/events`

Prints all events for the specified plugin.

```shell
$ curl -s unifi.poller:37288/api/v1/output/Loki/events | jq .
{
  "Loki": {
    "latest": "2020-07-03T04:05:58.656262803-07:00",
    "events": [
      {
        "ts": "2020-07-03T03:09:58.376113474-07:00",
        "msg": "Loki Event collection started, interval: 2m0s, URL: http://loki:3100",
        "tags": {
          "type": "info"
        }
      },
      {
        "ts": "2020-07-03T04:05:58.656262803-07:00",
        "msg": "Events sent to Loki. Event: 0, IDS: 0, Alarm: 0, Anomaly: 0, Dur: 280ms",
        "tags": {
          "type": "info"
      }
    }
  ]
```

## `/api/v1/input/<input>`

Prints configuration for `<input>` input plugin.

```shell
$ curl -s unifi.poller:37288/api/v1/input/unifi | jq .
{
  "defaults": {
    "verify_ssl": false,
    "save_anomalies": false,
    "save_alarms": false,
    "save_events": false,
    "save_ids": false,
    "save_dpi": false,
    "hash_pii": false,
    "save_sites": true,
    "user": "unifipoller",
    "pass": "true",
    "url": "https://127.0.0.1:8443",
    "sites": [
      "all"
    ]
  },
  "disable": false,
  "dynamic": false,
  "controllers": [
    {
      "verify_ssl": false,
      "save_anomalies": true,
      "save_alarms": true,
      "save_events": true,
      "save_ids": true,
      "save_dpi": true,
      "hash_pii": false,
      "save_sites": true,
      "user": "unifipoller",
      "pass": "true",
      "url": "https://unifi-controller:8443",
      "sites": [
        "all"
      ],
      "id": "572e0211-a02a-4d09-b6a5-bad63fb76f1c"
    }
  ]
}
```

## `/api/v1/input/<input>/eventgroups`

Prints all event-groups present for the requested input plugin.
Currently the `unifi` input plugin has one group for the plugin
itself, and four groups for each configured controller. The
four groups are `alarms`, `events`, `ids`, `anomalies`, and each
is prefixed with the controller UUID.

```shell
$ curl -s unifi.poller:37288/api/v1/input/unifi/eventgroups | jq .
[
  "572e0211-a02a-4d09-b6a5-bad63fb76f1c_alarms",
  "572e0211-a02a-4d09-b6a5-bad63fb76f1c_events",
  "unifi",
  "572e0211-a02a-4d09-b6a5-bad63fb76f1c_ids",
  "572e0211-a02a-4d09-b6a5-bad63fb76f1c_anomalies"
]
```

## `/api/v1/input/<input>/events/<group>`

Prints events specific to the requested input and group.

```json
curl -s unifi.poller:37288/api/v1/input/unifi/events/unifi | jq .
{
  "latest": "2020-07-04T00:30:04.461330789-07:00",
  "events": [
    {
      "ts": "2020-07-04T00:28:31.824048428-07:00",
      "msg": "Requested https://unifi-controller:8443/api/s/default/stat/anomalies?scale=hourly&end=1593847711000: elapsed 7ms, returned 421 bytes",
      "tags": {
        "type": "debug"
      }
    },
    {
      "ts": "2020-07-04T00:32:04.45699961-07:00",
      "msg": "Unmarshalling Device Type: usw, site Home (default) ",
      "tags": {
        "type": "debug"
      }
    },
    {
      "ts": "2020-07-04T00:32:04.461339777-07:00",
      "msg": "Unmarshalling Device Type: uap, site Home (default) ",
      "tags": {
        "type": "debug"
      }
    }
  ]
}
```

## `/api/v1/input/<input>/events`

Prints all events for the specified plugin.
Looks like output plugin events.

## `/api/v1/input/<input>/sites`

Prints the most recently collected sites and some meta data.

```shell
$ curl -s unifi.poller:37288/api/v1/input/unifi/sites | jq .
[
  {
    "id": "574e86664333ffb999a2683f",
    "name": "default",
    "desc": "Home",
    "source": "https://unifi-controller:8443",
    "controller": "572e0211-a02a-4d09-b6a5-bad63fb76f1c"
  }
]
```

## `/api/v1/input/<input>/clients`

Prints the most recently collected clients and some meta data.

```shell
$ curl -s unifi.poller:37288/api/v1/input/unifi/clients | jq .
[
  {
    "rx_bytes": 2273696,
    "tx_bytes": 4029181,
    "name": "RMPROPLUS-43-3c-88",
    "site_id": "574e86664333ffb999a2683f",
    "source": "https://unifi-controller:8443",
    "controller": "572e0211-a02a-4d09-b6a5-bad63fb76f1c",
    "mac": "34:ea:34:43:3c:88",
    "ip": "192.168.1.17",
    "type": "wireless",
    "device_mac": "b4:fb:e4:d2:74:39",
    "since": "2020-03-29T04:37:32-07:00",
    "last": "2020-07-03T04:10:36-07:00"
  },
  {
    "rx_bytes": 1530352814,
    "tx_bytes": 205398316,
    "name": "ubuntu",
    "site_id": "574e86664333ffb999a2683f",
    "source": "https://unifi-controller:8443",
    "controller": "572e0211-a02a-4d09-b6a5-bad63fb76f1c",
    "mac": "52:54:00:9a:ea:9e",
    "ip": "",
    "type": "wired",
    "device_mac": "80:2a:a8:5d:86:32",
    "since": "2020-05-03T04:37:21-07:00",
    "last": "2020-07-03T04:10:46-07:00"
  }
]
```

## `/api/v1/input/<input>/devices`

Prints the most recently collected devices and some meta data.

```shell
$ curl -s unifi.poller:37288/api/v1/input/unifi/devices | jq .
[
  {
    "clients": 3,
    "uptime": 4835552,
    "name": "wap-lower",
    "site_id": "574e86664333ffb999a2683f",
    "source": "https://unifi-controller:8443",
    "controller": "572e0211-a02a-4d09-b6a5-bad63fb76f1c",
    "mac": "80:2a:a8:11:ea:78",
    "ip": "192.168.1.14",
    "type": "uap",
    "model": "U7PG2",
    "version": "4.3.13.11253"
  },
  {
    "clients": 14,
    "uptime": 4834600,
    "name": "wap-upper",
    "site_id": "574e86664333ffb999a2683f",
    "source": "https://unifi-controller:8443",
    "controller": "572e0211-a02a-4d09-b6a5-bad63fb76f1c",
    "mac": "b4:fb:e4:d2:46:93",
    "ip": "192.168.1.215",
    "type": "uap",
    "model": "U7NHD",
    "version": "4.3.13.11253"
  },
  {
    "clients": 2,
    "uptime": 4834344,
    "name": "wap-wall",
    "site_id": "574e86664333ffb999a2683f",
    "source": "https://unifi-controller:8443",
    "controller": "572e0211-a02a-4d09-b6a5-bad63fb76f1c",
    "mac": "74:83:c2:d4:22:d3",
    "ip": "192.168.1.190",
    "type": "uap",
    "model": "UHDIW",
    "version": "4.3.13.11253"
  },
  {
    "clients": 19,
    "uptime": 4834869,
    "name": "switch",
    "site_id": "574e86664333ffb999a2683f",
    "source": "https://unifi-controller:8443",
    "controller": "572e0211-a02a-4d09-b6a5-bad63fb76f1c",
    "mac": "80:2a:a8:5d:68:23",
    "ip": "192.168.1.7",
    "type": "usw",
    "model": "US48P750",
    "version": "4.3.13.11253"
  },
  {
    "clients": 26,
    "uptime": 4921914,
    "name": "gateway",
    "site_id": "574e86664333ffb999a2683f",
    "source": "https://unifi-controller:8443",
    "controller": "572e0211-a02a-4d09-b6a5-bad63fb76f1c",
    "mac": "74:83:c2:1a:53:93",
    "ip": "67.181.75.120",
    "type": "ugw",
    "model": "UGW4",
    "version": "4.4.51.5287926"
  }
]
```
