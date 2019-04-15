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

## Troubleshooting

If you're getting errors like this: 
```
[ERROR] infdb.Write(bp): {"error":"field type conflict"}
[ERROR] infdb.Write(bp): {"error":"partial write: field type conflict: input field "tx_power" on measurement "uap_radios" is type integer, already exists as type float dropped="}
```

This usually indicates a bug was fixed and the resulting fixed has caused an incompatibility with your existing InfluxDB database. This could also indicate you've found a new bug. Please open an issue if you are running the latest version and dropping the database did not solve the error. There are generally two fixes: 
1. Downgrade. Do not upgrade to a new version. 
2. `DROP` and re-`CREATE` the InfluxDB database.