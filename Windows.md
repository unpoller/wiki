This application compiles and runs just fine on Windows. There is very little support provided. If you know how to package apps on windows, how and where config files should live, and how to auto-start a binary, open an Issue or submit a pull request so we can make this better.

As it is now, a pre-compiled windows binary (.exe) is provided on the [Releases](https://github.com/unifi-poller/unifi-poller/releases) page. Combine this with a valid [config file](https://github.com/unifi-poller/unifi-poller/blob/master/examples/up.conf.example) and you can run this on Windows.

```shell
unifi-poller.exe -c up.conf
```
