This project provides a few Grafana dashboards. They used to be installed as part
of the packages and available in this repo, but they have been moved to
[Grafana.com](https://grafana.com/dashboards?search=unifi-poller) to simplify installation.

Keep in mind these dashboards are just examples. You should make a single dedicated folder
in Grafana to keep all of them in, and copy the graphs to new dashboards that you want to maintain.
From time to time I will release new features (like multi-site support) that brings
new benefits to the existing dashboards. When that happens I update them.
Keeping an Example set allows you to update too, inspect the changes, and apply them
to your own custom dashboards.

**Note**: Do not make one folder per dashboard. Make one folder for all of them.
The folder name cannot be the same as the dashboard names, or Grafana will throw an error.

Recommendations:

-   Import the provided dashboards into their own folder, so they're easy to find.
-   Use the `Upload .json File` button to import the dashboards.
-   Changing the unique identifier allows you to re-import a dashboard, but this is not recommended.
-   Don't edit them.
-   Copy these dashboards or graphs to your own.
-   Edit the copies to get the data how you want it.
-   Keeping the original dashboards unedited, allows you to continue referencing them, and copying graphs out of them.
-   This also allows you to identify problems with them and open an [Issue](https://github.com/unifi-poller/unifi-poller/issues).

The dashboards use a few plugins. See the [Grafana wiki page](Grafana) for that information.

When the dashboards are updated, you have a couple options to update them in Grafana.
You can either import them and replace the existing ones (use the same unique identifier),
or you can import them as fresh new dashboards by changing the unique identifier.
This allows you to keep updating the provided dashboards while maintaining your own.
From time to time the dashboards get new features, new graphs, new variables, etc.
Giving yourself an easy way to import the updated dashboards provided by this project is ideal.
You're able to inspect the changes and apply them to your dashboards with this method.
