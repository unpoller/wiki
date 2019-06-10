This project provides a few Grafana dashboards. The package installs them into `/usr/share/doc/uniti-poller` (Linux) or `/usr/local/share/doc/unifi-poller` (macOS). You can also [download them from GitHub](https://github.com/davidnewhall/unifi-poller/tree/master/examples).

Recommendation:

- Import the provided dashboards into their own folder, so they're easy to find.
- Use the `Upload .json File` button to import the dashboards.
- Changing the unique identifier allows you to re-import a dashboard.
- Don't edit them. 
- Copy these dashboards to your own. 
- Edit the copies to get the data how you want it.
- Keeping the original dashboards unedited, allows you to continue referencing them, and copying graphs out of them.
- This also allows you to identify problems with them and open an [Issue](https://github.com/davidnewhall/unifi-poller/issues).

The dashboards use a few plugins. See the [Grafana wiki page](Grafana) for that information. 

When the dashboards are updated, you have a couple options to update them in Grafana. You can either import them and replace the existing ones (use the same unique identifier), or you can import them as fresh new dashboards by changing the unique identifier. This allows you to keep updating the provided dashboards while maintaining your own. From time to time the dashboards get new features, new graphs, new variables, etc. Giving yourself an easy way to import the updated dashboards provided by this project is ideal. You're able to inspect the changes and apply them to your dashboards with this method.