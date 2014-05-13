#! /usr/bin/env bash

DIR=$(dirname $0)
PWD=$(pwd)

export OCI_HOME=$PWD/instantclient_12_1
export OCI_LIB_DIR=$OCI_HOME
export OCI_INCLUDE_DIR=$PWD/instantclient_12_1/sdk/include
export OCI_VERSION=12
export NLS_LANG=AMERICAN_AMERICA.UTF8
