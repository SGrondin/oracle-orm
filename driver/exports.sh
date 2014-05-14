#! /usr/bin/env bash

module=$(dirname $0)
pushd $module/../.. > /dev/null
project=$(pwd)
popd > /dev/null

export OCI_HOME=$project/instantclient_12_1
export OCI_LIB_DIR=$OCI_HOME
export OCI_INCLUDE_DIR=$project/instantclient_12_1/sdk/include
export OCI_VERSION=12
export NLS_LANG=AMERICAN_AMERICA.UTF8
