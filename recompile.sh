#!/usr/bin/env bash

DIR=$(dirname $0)
pushd $DIR > /dev/null

if [[ ! -d node_modules ]]; then
	echo 'Installing compiler tools...'
	sleep 1
	npm install
fi

echo 'Compiling oracle-orm...'

node_modules/streamline/bin/_coffee -c src/
rm lib/*.js
mv src/*.js lib/

popd > /dev/null
echo 'Done!'
