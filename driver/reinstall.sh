#! /usr/bin/env bash

module=$(pwd)
pushd $module/../..
project=$(pwd)
popd

if [[ -f $module/driver/installed ]]; then
	echo 'exiting'
	exit
fi

source $module/driver/exports.sh

pushd $OCI_LIB_DIR
unlink libocci.so
unlink libclntsh.so
ln -s libocci.so.12.1 libocci.so
ln -s libclntsh.so.12.1 libclntsh.so
popd

echo $OCI_HOME/ | sudo tee /etc/ld.so.conf.d/oracle_instant_client.conf
sudo ldconfig

touch driver/installed
npm install
