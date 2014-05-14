#! /usr/bin/env bash

module=$(pwd)
pushd $module/../.. > /dev/null
project=$(pwd)
popd > /dev/null

if [[ $module/driver/installed ]]; then
	exit
fi

source $module/driver/exports.sh

pushd $OCI_LIB_DIR > /dev/null
unlink libocci.so
unlink libclntsh.so
ln -s libocci.so.12.1 libocci.so
ln -s libclntsh.so.12.1 libclntsh.so
popd > /dev/null

echo $OCI_HOME/ | sudo tee /etc/ld.so.conf.d/oracle_instant_client.conf
sudo ldconfig

pushd $module > /dev/null
touch driver/installed
npm install --dev
popd > /dev/null
