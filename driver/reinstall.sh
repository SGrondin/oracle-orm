#! /usr/bin/env bash

DIR=$(dirname $0)
PWD=$(pwd)
source $DIR/exports.sh

pushd $OCI_LIB_DIR > /dev/null
unlink libocci.so
unlink libclntsh.so
ln -s libocci.so.12.1 libocci.so
ln -s libclntsh.so.12.1 libclntsh.so
popd > /dev/null

echo $OCI_HOME/ | sudo tee /etc/ld.so.conf.d/oracle_instant_client.conf
sudo ldconfig

pushd $DIR/.. > /dev/null
rm -r node_modules > /dev/null
npm install
popd > /dev/null
