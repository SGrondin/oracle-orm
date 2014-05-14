#! /usr/bin/env bash

module=$(pwd)

if [[ -f $module/driver/installed ]]; then
	exit
fi
if [[ ! -d $module/../../instantclient_12_1 ]]; then
	echo 'Cannot find ../../instantclient_12_1'
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

touch driver/installed
sleep 3 # Make sure sudo prompt has time to pop up
npm install # DevDependencies
