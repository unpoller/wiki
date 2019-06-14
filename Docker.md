# Work In Progress

A docker image is available on [Docker Hub](https://hub.docker.com/r/golift/unifi-poller). See this [contribution](https://github.com/davidnewhall/unifi-poller/pull/38) for information on where the image comes from. Many thanks to [mabunixda](https://github.com/mabunixda)!

You may download the latest version with this command:
```shell
docker pull golift/unifi-poller
```
The latest version may contain bugs; thank you for beta testing. 

You can install a released version using a tag like this:
```shell
docker pull golift/unifi-poller:v1.3.0
```

You can build your own image from source.
```shell
git clone https://github.com/davidnewhall/unifi-poller.git
cd unifi-poller
make docker
```

To run the container use following command:
```shell
docker run -d -v /your/config/up.conf:/etc/unifi-poller/up.conf golift/unifi-poller:v1.3.0
```
Just fetch the [configuration from the repository](https://github.com/davidnewhall/unifi-poller/blob/master/examples/up.conf.example) and mount it as overlay into the container. The example configuration file is also included in the container at the default location _/etc/unifi-poller/up.conf_

To avoid a password in your configuration file just use the following parameter on your docker run command:
```shell
docker run -e UNIFI_PASSWORD="your-secret-pasword" -d -v /your/config/up.conf:/etc/unifi-poller/up.conf golift/unifi-poller:v1.3.0
```
