#!/bin/bash

# configuration options
export LUCEE_VERSION="5.0.1.85"
export JVM_MAX_HEAP_SIZE="512m"
# to find the download path, go to Oracle's JRE Downloads page (http://www.oracle.com/technetwork/java/javase/downloads/)
# and find the path to the Linux x64 JDK
export JDK_DOWNLOAD=http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz


#root permission check
if [ "$(whoami)" != "root" ]; then
  echo "Sorry, you need to run this script using sudo or as root."
  exit 1
fi

function separator {
  echo " "
  echo "------------------------------------------------"
  echo " "
}

#make sure scripts are runnable
chown -R root scripts/*.sh
chmod u+x scripts/*.sh

#update ubuntu software
./scripts/100-os-update.sh
separator

#download lucee
./scripts/200-lucee.sh
separator

#install tomcat
./scripts/300-tomcat.sh
separator

#install jvm
./scripts/400-jvm.sh $JDK_DOWNLOAD
separator

#install nginx
./scripts/500-nginx.sh
separator

echo "Setup Complete"
separator
echo "GO SET YOUR LUCEE PASSWORDS: http://localhost/lucee/admin/server.cfm"
