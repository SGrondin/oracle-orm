#! /usr/bin/env bash

module=$(pwd)

if [[ $ORACLE_ORM_INSTALLED == 'TRUE' ]]; then # Stop the npm install recursion
	exit
fi
if [[ ! -d $module/../../instantclient_12_1 ]]; then
	echo 'Fatal error: cannot find ../../instantclient_12_1'
	exit -1
fi

source $module/driver/exports.sh

pushd $OCI_LIB_DIR > /dev/null
unlink libocci.so 2> /dev/null
unlink libclntsh.so 2> /dev/null
ln -s libocci.so.12.1 libocci.so
ln -s libclntsh.so.12.1 libclntsh.so
popd > /dev/null

sleep 5 # Make sure sudo prompt has time to pop up
echo 'oracle-orm needs sudo to set the Oracle environment variables.'
echo $OCI_HOME/ | sudo tee /etc/ld.so.conf.d/oracle_instant_client.conf
sudo ldconfig

# Write to /etc/environment because instantclient needs it
nlslang=$(cat /etc/environment | grep "^NLS_LANG=" | wc -l)
if [[ $nlslang == 0 ]]; then
	echo 'NLS_LANG='$NLS_LANG | sudo tee -a /etc/environment > /dev/null
fi

export ORACLE_ORM_INSTALLED=TRUE # Stop the npm install recursion
npm install # DevDependencies
