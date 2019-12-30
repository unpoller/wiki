This document provides instructions to install Grafana.
You can find official instructions in the [Grafana Docs](https://grafana.com/docs/installation/).
After installing Grafana, you should [import the provided dashboards](Grafana-Dashboards).

**Grafana 5.5 or newer is required. Grafana 4.x will not work. Grafana 6.x+ is recommended.**

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

[Download them here](https://grafana.com/dashboards?search=unifi-poller).
More information and best practices can be found on the [Grafana Dashboards Wiki Page](Grafana-Dashboards).

The most important part! Something to quickly visualize all the data you're collecting!
The dashboards used to be in this repository, but they've been moved to [Grafana.com](https://grafana.com/dashboards?search=unifi-poller).
You can install all of them, or only install the ones that interest you. Directions are available on each dashboard's page.
