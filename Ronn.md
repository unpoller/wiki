## Installing Ronn

Ronn is a tool that converts [markdown](https://github.com/davidnewhall/unifi-poller/blob/master/cmd/unifi-poller/README.md) (and other) files into Unix man pages. The man page step is baked into the Makefile, so having ronn available is required for beginners. If you know how to read a [Makefile](https://github.com/davidnewhall/unifi-poller/blob/master/Makefile) and run the commands yourself and install unifi-poller you can skip ronn installation.

### RedHat/Fedora variants

```shell
sudo yum install ruby-devel -y 
sudo gem install ronn --no-document
```

### Debian/Ubuntu variants

```shell
sudo apt install -y rubygems
sudo gem install ronn --no-document
```

### macOS

You need the Xcode CLI tools installed, but if you're reading this on a Mac, you probably have that, and hopefully [brew](http://brew.sh).

```
sudo gem install ronn --no-document
```