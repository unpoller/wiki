## A docker image is available on [Docker Hub](https://hub.docker.com/r/golift/unifi-poller/tags). 

See this [contribution](https://github.com/davidnewhall/unifi-poller/pull/38) for information on where the image comes from. Many thanks to [mabunixda](https://github.com/mabunixda)! The images are [built automatically](https://cloud.docker.com/repository/docker/golift/unifi-poller/builds) by Docker Cloud using the [Dockerfile](https://github.com/davidnewhall/unifi-poller/blob/master/Dockerfile) included in this repo. 

# Install 

You can install `latest`, `stable` (recommended), or pick a specific version. See the following sections for information on how to do each.

### Stable Release
You may install the current stable released version using a tag like this:
```shell
docker pull golift/unifi-poller:stable
```

### Latest (master)
You may download the latest version with this command:
```shell
docker pull golift/unifi-poller:latest
```
The latest version is based from `master` branch and may contain bugs; thank you for beta testing. 

### Pick a version
You may install the latest released minor version like this:
```shell
docker pull golift/unifi-poller:1.3
```
The above example will download version 1.3.2 (or whatever the latest release in the 1.3 line is).

Install a specific version like this:
```shell
docker pull golift/unifi-poller:1.3.2
```

### From Source
You can build your own image from source.
```shell
git clone https://github.com/davidnewhall/unifi-poller.git
cd unifi-poller
make docker
```

# Running the Container
Make sure you've completed the prerequisites in the [Installation](Installation) article.

This command starts the container as a daemon:
```shell
docker run -d -v /your/config/up.conf:/etc/unifi-poller/up.conf golift/unifi-poller:stable
```
Copy the [example configuration file](https://github.com/davidnewhall/unifi-poller/blob/master/examples/up.conf.example) from this repository and mount it as an overlay into the container. The example configuration file is also included in the container at the default location _/etc/unifi-poller/up.conf_

To avoid writing a password in your configuration file, it may be passed in as an environment variable. If you do this, do not include a the password in the config file, or it will be used instead. Here's an example:
```shell
docker run -e UNIFI_PASSWORD="your-secret-pasword" -d -v /your/config/up.conf:/etc/unifi-poller/up.conf golift/unifi-poller:stable
```