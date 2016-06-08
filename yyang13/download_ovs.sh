#!/bin/bash

URL_OVS=https://github.com/openvswitch/ovs.git
OVS_COMMIT=7d433ae57ebb90cd68e8fa948a096f619ac4e2d8
WORKING_DIR=`pwd`

if [ -d openvswitch ] ;then
    echo "Already openvswitch directory exists!"
    exit
fi

echo "Download OpenvSwitch source..."
git clone $URL_OVS openvswitch

echo "Apply NSH patches..."
cd openvswitch
git checkout $OVS_COMMIT -b development

PATCHES=$(cd ../patches; echo *patch; cd ../openvswitch)
for patch in ${PATCHES}
do
    patch -p1 < ${WORKING_DIR}/patches/${patch}
done
