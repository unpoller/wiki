This document provides instructions to install Grafana.

This will set it up on localhost:3000 with admin/admin login.

# Linux

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
- Clock, Discrete, PieChart
```shell
grafana-cli plugins install grafana-clock-panel
grafana-cli plugins install natel-discrete-panel
grafana-cli plugins install grafana-piechart-panel
```