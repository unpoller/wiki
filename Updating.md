If you've already followed the [Installation Wiki](Installation) guide and you want to update to a newer version of unifi-poller or the [unifi](https://github.com/golift/unifi) go library (or [other libraries](https://github.com/davidnewhall/unifi-poller/blob/master/Gopkg.lock)), it's pretty easy.

Go back to your git checkout for unifi-poller, or clone it again.
```shell
git clone git@github.com:davidnewhall/unifi-poller.git
cd unifi-poller
```

Update app & vendors. This will bring everything up to, what should be, a compatible version.
```shell
git pull 
make deps
```

Test First (optional)
```shell
make test
```

Reinstall. This just replaces the binary. The config file is not touched. The app is restarted.
```shell
sudo make install
```