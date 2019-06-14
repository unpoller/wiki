# Work In Progress

A docker image is available on [Docker Hub](https://hub.docker.com/r/golift/unifi-poller). You may download the latest version with this command:
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