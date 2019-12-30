# UniFi Poller Wiki

[![travis](https://badgen.net/travis/unifi-poller/wiki?icon=travis&label=build "Travis Build")](https://travis-ci.org/unifi-poller/wiki)

The wiki for UniFi Poller is located in its own [GitHub repository](https://github.com/unifi-poller/wiki),
and may be reading this README in that repo.

If you wish to make changes to the wiki, please clone the main repo, and create
a pull request with your changes.

To run the linter locally, I had to do this on my Mac:

```shell
brew install rbenv ruby-build
rbenv install 2.6.5
rbenv shell 2.6.5
gem install mdl
mdl .
```
