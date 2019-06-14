**If you installed a package** and `unifi-poller` is working, updating is simple: [Download](https://github.com/davidnewhall/unifi-poller/releases) and install a new package. The package will correctly restart `unifi-poller` after upgrading and will not overwrite your existing configuration file(s). After installing the new package, you may choose to [import updated dashboards](Grafana-Dashboards).

macOS: `brew upgrade unifi-poller`

**If you followed the [Installation Wiki](Installation)** guide and you want to update to a newer version of `unifi-poller` or the [unifi](https://github.com/golift/unifi) go library (or [other libraries](https://github.com/davidnewhall/unifi-poller/blob/master/Gopkg.lock)), it's pretty easy. Just go through the process again. 

If you want to build and install a new package:

Go back to your git checkout for unifi-poller, or clone it again.
```shell
git clone git@github.com:davidnewhall/unifi-poller.git
cd unifi-poller
```

Update app & vendors. This will bring everything up to, what should be, a compatible version.
```shell
git pull 
dep ensure
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
```
# redhat/centos/fedora:
rpm -Uvh *.rpm || dpkg -i *.deb
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