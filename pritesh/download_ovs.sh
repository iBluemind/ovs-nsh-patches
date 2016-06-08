#!/bin/bash

URL_OVS=https://github.com/pritesh/ovs.git
OVS_COMMIT=nsh-v8

if [ ! -d openvswitch ] ;then
    echo "Download OpenvSwitch source applied NSH patches..."
    git clone $URL_OVS openvswitch
fi

cd openvswitch
git checkout $OVS_COMMIT

