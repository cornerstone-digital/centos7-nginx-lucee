#!/bin/bash

# configuration options
export LUCEE_VERSION="5.2.4.37"
export YUM_OPTIONS="--assumeyes --quiet"
export JVM_MAX_HEAP_SIZE="512m"
# to find the download path, go to Oracle's JRE Downloads page (http://www.oracle.com/technetwork/java/javase/downloads/)
# and find the path to the Linux x64 JDK
export JDK_DOWNLOAD=http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz
# define the webroot
export WEB_ROOT="/web"

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
echo ""
echo "Important information"
echo "====================="
echo ""
echo "* You must setup you Lucee Passwords: http://127.0.0.1/lucee/admin/server.cfm"
echo "* If you do not want to use $WEB_ROOT/example.com, then clean up the folder"
echo ""
