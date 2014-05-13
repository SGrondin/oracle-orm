Installing the Node-Oracle driver
=================================

Go to your project's directory.

```bash
sudo apt-get install libaio1

# Go to http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html
# Click on Linux x86-64
# Download instantclient-basic-***.zip and instantclient-sdk-***.zip
# unzip both into YOUR_PROJECT/instantclient_12_1

npm install oracle-orm

./node_modules/oracle-orm/driver/reinstall.sh

```
