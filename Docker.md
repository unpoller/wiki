## Docker images are available on [Docker Hub](https://hub.docker.com/r/golift/unifi-poller/tags). 

Many thanks to [mabunixda](https://github.com/mabunixda) for the [helping](https://github.com/davidnewhall/unifi-poller/pull/38) begin our Docker support! The images are [built automatically](https://cloud.docker.com/repository/docker/golift/unifi-poller/builds) by Docker Cloud using the [Dockerfile](https://github.com/davidnewhall/unifi-poller/blob/master/init/docker/Dockerfile) included in this repo. 

# Install 

You can install `latest`, `stable` (recommended), or pick a specific version. See the following sections for information on how to do each.

#### Stable Release
You may install the current stable released version using a tag like this:
```shell
docker pull golift/unifi-poller:stable
```
This is the recommended way to install. Linux images are available for 386, amd64, arm32v6 and arm64v8. There is no need to specify an arch tag, docker will pull the correct image automatically with the `stable` tag.

#### Latest (master)
You may download the `latest` version with this command:
```shell
docker pull golift/unifi-poller:latest
```
Using `latest` is not recommended. You may be asked to give this a try while troubleshooting or debugging, but generally this will contain untested code or things that will break your graphs. The latest version is based from the `master` branch and may contain bugs. 

#### Pick a version
Install a specific version like this:
```shell
docker pull golift/unifi-poller:1.5.4
```

#### From Source
You can build your own image from source.
```shell
git clone https://github.com/davidnewhall/unifi-poller.git
cd unifi-poller
make docker
```
This builds a 64-bit amd64 linux image from scratch. If you need another architecture, use the `docker build` command directly with a correct `--build-arg` flag. [Examples here](https://github.com/davidnewhall/unifi-poller/tree/master/init/docker/hooks).

# Running the Container

*   **Make sure you've completed the prerequisites in the [Installation](Installation) article.**

This command starts the container as a daemon:
```shell
docker run -d -v /your/config/up.conf:/etc/unifi-poller/up.conf golift/unifi-poller:stable
```
Copy the [example configuration file](https://github.com/davidnewhall/unifi-poller/blob/master/examples/up.conf.example) from this repository and mount it as an overlay into the container. The example configuration file is also included in the container at the default location _/etc/unifi-poller/up.conf_

#### Environment Variables

As of version 1.5.3 all configuration options may be passed as environment variables.
Here's an example:
```shell
docker run -e UP_UNIFI_PASS="your-secret-pasword" -e UP_DEBUG="true" -d golift/unifi-poller:stable
```
##### Available Variables
|ENV v1.5|ENV v1.6|config|note|
|---|---|---|---|
UP_POLLING_MODE|UP_MODE|mode|`"influx"` (default), `"influxlambda"` or `"prometheus"`
UP_INFLUX_DB|UP_INFLUX_DB| influx_db | default `"unifi"`
UP_INFLUX_USER|UP_INFLUX_USER| influx_user| default `"unifi"`
UP_INFLUX_PASS|UP_INFLUX_PASS| influx_pass | default `"unifi"`
UP_INFLUX_URL|UP_INFLUX_URL| influx_url | default `"http://127.0.0.1:8086"`
UP_UNIFI_USER|UP_UNIFI_USER| unifi_user | default "influx"
UP_UNIFI_PASS|UP_UNIFI_PASS| unifi_pass |
UP_UNIFI_URL|UP_UNIFI_URL| unifi_url | default `"https://127.0.0.1:8443"`
UP_REAUTHENTICATE|UP_REAUTHENTICATE| reauthenticate | default `"false"`
UP_VERIFY_SSL|UP_VERIFY_SSL|verify_ssl|default `"false"`
UP_COLLECT_IDS|UP_SAVE_IDS|save_ids| default `"false"`
||UP_SAVE_SITES|save_sites| default `"true"`
UP_QUIET_MODE|UP_QUIET|quiet| default `"false"`
UP_DEBUG_MODE|UP_DEBUG|debug| default `"false"`
UP_POLLING_INTERVAL|UP_INTERVAL|interval|Go duration. ie `"1m"` or `"90s"`, default `"30s"`
UP_POLL_SITES|UP_SITES|sites|separate sites with commas, default `"all"`
||UP_NAMESPACE|namespace|top level Prometheus namespace. Default `"unifipoller"`
||UP_HTTP_LISTEN|http_listen|Prometheus HTTP listen address, `ip:port`. You will likely want to publish this port on the host.

# Docker Compose

Included with version 1.5.3 is a Docker Compose file and example environment variable configuration to make it work. If you do not have Grafana or InfluxDB running already, then this is a great option to let you try this software. TODO: finish this section...... 9/9/19 - give credit to jon.