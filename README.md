# UniFi Poller Wiki

[![travis](https://badgen.net/travis/unifi-poller/wiki?icon=travis&label=build "Travis Build")](https://travis-ci.org/unifi-poller/wiki)

The wiki for UniFi Poller is located in its own
[GitHub repository](https://github.com/unifi-poller/wiki). This one.

If you wish to make changes to the wiki, please clone the this repo, and create
a pull request with your changes. Target the `testing` branch in your pull request.
Merges to `testing` are pushed automatically to the
[local test wiki](https://github.com/unifi-poller/wiki/wiki) on this repo.
Once the `testing` branch is merged to `master` the changes are deployed to the
[main wiki](https://github.com/unifi-poller/unifi-poller/wiki).

To run the linter locally, I had to do this on my Mac, but `bundler` may work too.

```shell
brew install rbenv ruby-build
rbenv install 2.6.5
rbenv shell 2.6.5
gem install mdl
mdl .
```
