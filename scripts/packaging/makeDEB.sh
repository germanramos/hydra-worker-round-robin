#!/bin/bash

### http://linuxconfig.org/easy-way-to-create-a-debian-package-and-local-package-repository

rm -rf ~/debbuild
mkdir -p ~/debbuild/DEBIAN
cp control ~/debbuild/DEBIAN

mkdir -p ~/debbuild/etc/init.d
cp hydra-worker-round-robin-init.d.sh ~/debbuild/etc/init.d/hydra-worker-round-robin

mkdir -p ~/debbuild/usr/local/hydra
cp ../../bin/hydra-worker-round-robin  ~/debbuild/usr/local/hydra

chmod -R 644 ~/debbuild/usr/local/hydra/* ~/debbuild/etc/hydra/*
chmod 755 ~/debbuild/etc/init.d/hydra-worker-round-robin
chmod 755 ~/debbuild/usr/local/hydra/hydra-worker-round-robin

sudo chown -R root:root ~/debbuild/*

pushd ~
sudo dpkg-deb --build debbuild

popd
sudo mv ~/debbuild.deb hydra-worker-round-robin-1-0.x86_64.deb
