#!/bin/bash

PATCH_NAME=$1

if [ -z "$PATCH_NAME" ]; then
    echo "Please set the patch name!"
    exit
fi

cd $PATCH_NAME/
./download_ovs.sh

echo "Removing all OpenvSwitch packages..."
sudo apt-get purge openvswitch-common openvswitch-datapath-source openvswitch-ipsec openvswitch-switch openvswitch-vtep openvswitch-datapath-dkms openvswitch-dbg openvswitch-pki openvswitch-test python-openvswitch ovn-central ovn-common ovn-docker ovn-host

echo "Removing the related OpenvSwitch configurations..."
sudo rm /etc/openvswitch/conf.db

echo "Installing the dependecies..."
sudo apt-get install -y build-essential fakeroot debhelper autoconf automake libssl-dev bzip2 openssl graphviz python-all procps python-qt4 python-zopeinterface python-twisted-conch libtool dh-autoreconf libcap-ng-dev

cd openvswitch/
sudo dpkg-checkbuilddeps

echo "Building OpenvSwitch packages for Debian..."
`DEB_BUILD_OPTIONS='parallel=8 nocheck' fakeroot debian/rules binary`

echo "Installing OpenvSwitch packages..."

sudo apt-get install -y linux-headers-`uname -r` dkms
sudo dpkg --install ../openvswitch-datapath-dkms*

sudo dpkg -i ../openvswitch-common*
sudo dpkg -i ../openvswitch-switch*

sudo apt-get install -f

sudo service openvswitch-switch restart

echo "Done!"

