Poller provides support for writing UniFi's Events, Anomalies, Alarms and IDS
data to Loki. There are no dashboards for this data, but it's pretty simple.
Just add a "Logs" panel. You can also use this data as an Annotation source.
Loki support was added in UniFi Poller v2.0.2.

Just add the Loki URL to your poller config to enable this output plugin.

```toml
[loki]
  url = "http://127.0.0.1:3100"
```

Use the UniFi input plugin settings to choose which logs to collect and save.
Example:

```toml
[unifi.defaults]
  save_ids       = true
  save_events    = true
  save_alarms    = true
  save_anomalies = true
```
