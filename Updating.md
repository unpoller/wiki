## Upgrading to Version 2

UniFi Poller version 2 changes the config file format and the env variable names.
This section intends to help you upgrade.

### Config File

If you only have 1 controller you can delete the `[[unifi.controlle]]` section
from `up.conf` and configure your control in the `[unifi.defaults]` section.

Copy your parameters from the existing config file into the new one. The names have
changes slightly, and each section has a `[header]` that must match. Use the [example
config file](https://github.com/unifi-poller/unifi-poller/blob/master/examples/up.conf.example)
for reference.

### Docker ENV Variables

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
