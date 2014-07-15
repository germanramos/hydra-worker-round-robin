#!/bin/bash

### http://tecadmin.net/create-rpm-of-your-own-script-in-centosredhat/#

sudo yum install rpm-build rpmdevtools
rm -rf ~/rpmbuild
rpmdev-setuptree

mkdir ~/rpmbuild/SOURCES/hydra-worker-round-robin-1
cp ./fixtures/hydra-worker-round-robin.conf  ~/rpmbuild/SOURCES/hydra-worker-round-robin-1
cp hydra-worker-round-robin-init.d.sh ~/rpmbuild/SOURCES/hydra-worker-round-robin-1
cp ../../bin/hydra-worker-round-robin ~/rpmbuild/SOURCES/hydra-worker-round-robin-1

cp hydra-worker-round-robin.spec ~/rpmbuild/SPECS

pushd ~/rpmbuild/SOURCES/
tar czf hydra-worker-round-robin-1.0.tar.gz hydra-worker-round-robin-1/
cd ~/rpmbuild 
rpmbuild -ba SPECS/hydra-worker-round-robin.spec

popd
cp ~/rpmbuild/RPMS/x86_64/hydra-worker-round-robin-1-0.x86_64.rpm .
