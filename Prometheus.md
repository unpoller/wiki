Prometheus support was add in the 1.6 release, but was never very well documented.
Release 2.0 brings with it a re-write of the prometheus integration. Many changes
were made to how one may configure a controller. This page only applies to version
2.0+.

This page explains how to configure Prometheus and unifi-poller.
For help installing Prometheus you'll have to look elsewhere;
that's not in this wiki at this time.

## Single Controller

Lets make the first example look a lot like the old v1.x way of doing things.
Configure a single controller in up.conf (or using environment variables).
See the [Configuration](Configuration) doc and the example config file for help with that.

Then you simply point prometheus to unifi-poller using a config like this:

```yaml
scrape_configs:
  - job_name: 'unifipoller'
    static_configs:
    - targets: ['localhost:9130']
```

If you have other scrape configs, leave them there. Just add a new one for `unifipoller`.
Replace `localhost` with the IP of the host running unifi-poller.
That's it! Restart prometheus and it should begin to scrape data from your controller.

## Multiple Controllers

You can scrape multiple controllers in several ways. Here is a list of options:

1.  Set all controller user/passwords the same and pass in controller URLs from Prometheus.
    To do this, you set the username and password as the default in the unifi config.
1.  Configure each controller in unifi-poller and pass in urls from Prometheus.
    This allows them to have different usernames and passwords.
1.  Configure each controller in unifi-poller with a role and pass in a role from
    Prometheus. This allows you to poll controllers in groups. Each role is a group
    you can pull data from. Each role can have 1 or more controllers, and each role
    can be configured independently in Prometheus.
1.  **Recommended:** Configure each controller in unifi-poller and configure prometheus as
    shown above in the Single Controller section. This is useful when you just want to poll
    all the controllers at the same time from a single prometheus instance. This is the
    most common approach.

### Approach: Poll by URL

You can either configure the controllers in unifi-poller or poll them unconfigured.
When polling unconfigured, you must enable `dynamic`.

#### Approach 1

This describes approach 1 above.

Using this approach all you need to configure for controllers in unifi-poller is
the name and password. Example below. Any settings you provide to `[unifi.defaults]`
will be used for all controllers passed in from Prometheus. All other settings
are optional.

```toml
[unifi]
  # This must be enabled to do dynamic polls against unconfigured urls.
  dynamic = true
[unifi.defaults]
  user       = "unifipoller"
  pass       = "unifipoller"
  sites      = ["all"]
  save_ids   = false
  save_dpi   = false
  save_sites = true
  verify_ssl = false
```

Or with env variables:

```shell
UP_UNIFI_DYNAMIC=true
UP_UNIFI_DEFAULT_USER="unifipoller"
UP_UNIFI_DEFAULT_PASS="unifipoller"
```

#### Approach 2

This describes approach 2 above.

Configure each controller in up.conf or using environment variables. When
Prometheus scrapes from unifi-poller the poller will map the URL directly to the
one configure in up.conf (or using env vars). Just make sure the url you put into
the prometheus configuration matches the url put into the poller configuration.

Example polling two controllers:

```toml
[unifi]
  # Not needed since not dynamic.
  dynamic = false
[[unifi.controller]]
  url = "http://unifi.controller:8443"
  user = "unifipoller1"
  pass = "unifipoller1"
[[unifi.controller]]
  url = "http://another.controller:8443"
  user = "unifipoller2"
  pass = "unifipoller2"
```

Or with env variables:

```shell
UP_UNIFI_DYNAMIC=false
UP_UNIFI_CONTROLLER_0_URL="http://unifi.controller:8443"
UP_UNIFI_CONTROLLER_0_USER="unifipoller"
UP_UNIFI_CONTROLLER_0_PASS="unifipoller"
UP_UNIFI_CONTROLLER_1_URL="http://another.controller:8443"
UP_UNIFI_CONTROLLER_1_USER="unifipoller"
UP_UNIFI_CONTROLLER_1_PASS="unifipoller"
```

#### Prometheus Configuration for URLs

This applies to approach 1 and 2 above. Configure prometheus like this:

```yaml
scrape_configs:
  - job_name: 'unifipoller'
    static_configs:
      - targets:
        - unifi:https://unifi.controller:8443
        - unifi:https://another.controller:8443
    metrics_path: /scrape
    relabel_configs:
     - source_labels: [__address__]
       target_label: __param_path
       regex: "[^:]+:(.*)"
       replacement: "$1"
     - source_labels: [__address__]
       target_label: __param_input
       regex: "([^:]+):.*"
       replacement: "$1"
     - source_labels: [__param_path]
       target_label: instance
     - target_label: __address__
       replacement: localhost:9130
```

As in the example above, replace `localhost` with the IP of your unifi-poller host,
and replace `unifi.controller` and `another.controller` with the IPs of your controllers.
The `unifi:` portion before the `https://` is required, so is the `https://`.

### Approach 3: Poll by Role

Example polling three controllers using roles:

```toml
[[unifi.controller]]
  role = "west"
  url = "http://unifi.controller:8443"
  user = "unifipoller1"
  pass = "unifipoller1"
[[unifi.controller]]
  role = "west"
  url = "http://another.controller:8443"
  user = "unifipoller2"
  pass = "unifipoller2"
[[unifi.controller]]
  role = "east"
  url = "http://east.controller:8443"
  user = "unifipoller3"
  pass = "unifipoller3"
```

Add to variables made above:

```shell
UP_UNIFI_CONTROLLER_0_ROLE="west"
UP_UNIFI_CONTROLLER_1_ROLE="west"
UP_UNIFI_CONTROLLER_2_ROLE="east"
UP_UNIFI_CONTROLLER_2_URL="http://east.controller:8443"
UP_UNIFI_CONTROLLER_2_USER="unifipoller"
UP_UNIFI_CONTROLLER_2_PASS="unifipoller"
```

#### Prometheus Configuration for Roles

This configuration is simplified to show how to poll each role.
The west roll will return metrics for two controllers.

```yaml
scrape_configs:
  - job_name: 'unifipoller'
    static_configs:
      - targets:
        - unifi:east
        - unifi:west
    metrics_path: /scrape
    relabel_configs:
     - source_labels: [__address__]
       target_label: __param_role
       regex: "[^:]+:(.*)"
       replacement: "$1"
     - source_labels: [__address__]
       target_label: __param_input
       regex: "([^:]+):.*"
       replacement: "$1"
     - source_labels: [__param_role]
       target_label: instance
     - target_label: __address__
       replacement: localhost:9130
```

Again, replace `localhost` with the IP of your unifi-poller host, and replace
`unifi.controller`, `another.controller` and `east.controller` with the IPs of
your controllers. The `unifi:` portion before the `https://` is required,
so is the `https://`.

### Approach 4, _Recommended_

Just configure your controllers in `up.conf` or using env variables as explained
in the [Configuration](Configuration) doc. Then setup Prometheus like this:

```yaml
scrape_configs:
  - job_name: 'unifipoller'
    static_configs:
    - targets: ['localhost:9130']
```

The standard `/metrics` path that the above snippet uses returns metrics for all
configured controllers.
