This document provides instructions to install Grafana.
You can find official instructions in the [Grafana Docs](https://grafana.com/docs/installation/).
After installing Grafana, you should import the provided dashboards (see below).

**Grafana 5.5 or newer is required. Grafana 4.x will not work. Grafana 6.5+ is recommended.**

This will set it up on localhost:3000 with admin/admin login.

# Linux

## CentOS 7

Get an RPM. [https://grafana.com/docs/installation/rpm/](https://grafana.com/docs/installation/rpm/)

## Ubuntu 18.04

```shell
curl https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt install -y apt-transport-https
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

sudo apt -y update && sudo apt -y install grafana
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server.service
sudo systemctl status grafana-server
```

# macOS

You need [Homebrew](https://brew.sh/):

```shell
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

```shell
brew install grafana
brew services restart grafana
brew services list
```

# Plugins

This application uses a few Grafana plugins. Install them:

-   `Clock`, `Discrete`, `PieChart`, `Singlestat` (standard), `Table` (standard)

```shell
grafana-cli plugins install grafana-clock-panel
grafana-cli plugins install natel-discrete-panel
grafana-cli plugins install grafana-piechart-panel
```

# Dashboards

This project provides a few Grafana dashboards. They are available on
[Grafana.com](https://grafana.com/dashboards?search=unifi-poller).

Keep in mind these dashboards are just examples. You should make a single dedicated folder
in Grafana to keep all of them in, and copy the graphs to new dashboards that you want to maintain.
From time to time I will release new features (like multi-site support and multi-controller support)
that brings new benefits to the existing dashboards. When that happens I update them.
Keeping an example set allows you to update too, inspect the changes, and apply them
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
-   Keeping the original dashboards unedited allows you to continue referencing them,
    and copying graphs out of them.
-   This also allows you to identify problems with them and open an
    [Issue](https://github.com/unifi-poller/unifi-poller/issues).

When the dashboards are updated, you have a couple options to update them in Grafana.
You can either import them and replace the existing ones (use the same unique identifier),
or you can import them as fresh new dashboards by changing the unique identifier.
This allows you to keep updating the provided dashboards while maintaining your own.
From time to time the dashboards get new features, new graphs, new variables, etc.
Giving yourself an easy way to import the updated dashboards provided by this project is ideal.
You're able to inspect the changes and apply them to your dashboards with this method.
