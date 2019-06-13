Beginning with version 1.1.1 architecture-specific packages are available for Debian/Ubuntu, RedHat/Fedora and macOS. This allows you to install a prebuilt binary, config file and startup script (systemd or launchd) without knowing anything about Go. The easy way. Pre-built packages are available on the [Releases](https://github.com/davidnewhall/unifi-poller/releases) page.

**If you already ran `make install` you need to run `make uninstall` before switching the install to a package.**

# Linux

Redhat and Fedora variants should download and install the rpm with something like this:
```shell
wget https://github.com/davidnewhall/unifi-poller/releases/download/v1.2.3/unifi-poller-1.2.3-119.x86_64.rpm
sudo rpm -Uvh unifi-poller*.rpm
```

Debian and Ubuntu variants should download and install the deb with something like this:
```shell
wget https://github.com/davidnewhall/unifi-poller/releases/download/v1.2.3/unifi-poller_1.2.3-119_amd64.deb
sudo dpkg -i unifi-poller*.deb
```

These packages install only a few files:
```
/etc/unifi-poller/up.conf
/lib/systemd/system/unifi-poller.service
/usr/bin/unifi-poller
/usr/share/man/man1/unifi-poller.1.gz
/usr/share/doc/unifi-poller/<examples>
```

Edit the config file after installing the package:
```shell
sudo nano /etc/unifi-poller/up.conf
# or
sudo vi /etc/unifi-poller/up.conf
```
Correct the authentication information for your setup.

Restart the service:
```shell
sudo systemctl restart unifi-poller
```

Check the log (may be different on RHEL):
```shell
tail -f -n100  /var/log/syslog /var/log/messages | grep unifi-poller
```

# macOS

Download the `.pkg` file from the [Releases](https://github.com/davidnewhall/unifi-poller/releases) pages. Double-click it. Continue, authenticate, etc.

Once the package is installed:

Edit the config file after installing the package:
```shell
nano /usr/local/etc/unifi-poller/up.conf
# or
vi /usr/local/etc/unifi-poller/up.conf
```
Correct the authentication information for your setup.

Start the service:
```shell
sudo launchctl load -w /Library/LaunchAgent/com.github.davidnewhall.unifi-poller.plist
```

The **log file** should show up at `/usr/local/var/log/unifi-poller/log`. If it does not show up, make sure `nobody` user has permissions to read and write to the folder.

If you need to restart it:
```shell
sudo launchctl unload /Library/LaunchAgent/com.github.davidnewhall.unifi-poller.plist
sudo launchctl load -w /Library/LaunchAgent/com.github.davidnewhall.unifi-poller.plist
```
If you accidentally run `launchctl` without `sudo` (as your own user) just `unload` it as your user too. It will not start because your user does not (should not) have access to write to the log folder, but you should still unload it.

The mac package installs the following files:
```
/usr/local/bin/unifi-poller
/usr/local/etc/unifi-poller/up.conf
/usr/local/etc/unifi-poller/up.conf.example
/usr/local/share/man/man1/unifi-poller.1.gz
/usr/local/var/log/unifi-poller/
/usr/local/share/doc/unifi-poller/<examples>
/Library/LaunchAgent/com.github.davidnewhall.unifi-poller.plist
```

# Manually

You can build your own package from source with the `Makefile`.

Follow the first few steps on the [Installation](Installation) page to get the Go environment setup. Then: `make deb` will build a Debian package, `make rpm` builds a RHEL package and `make osxpkg` builds a macOS package (only works on macOS).

You need `fpm` installed to build your own packages, see directions here: https://fpm.readthedocs.io/en/latest/installing.html
- tl;dr: `sudo gem install --no-document fpm`

If you're building linux packages on a mac you can run `brew install rpmbuild gnu-tar` to get the additional tools you need.