#!/bin/bash

jar_url="http://cdn.lucee.org/rest/update/provider/loader/$LUCEE_VERSION"
jar_folder="lucee-$LUCEE_VERSION"

echo "Installing Lucee"
echo "Downloading Lucee " $LUCEE_VERSION
mkdir -p /opt/lucee
mkdir -p /opt/lucee/config
mkdir -p /opt/lucee/config/server
mkdir -p /opt/lucee/config/web
mkdir -p /opt/lucee/$jar_folder
curl --location -o /opt/lucee/$jar_folder/lucee.jar $jar_url

if [ -f "/opt/lucee/$jar_folder/lucee.jar" ]; then
  echo "Download Complete"
else
  echo "Download of Lucee Failed Exiting..."
  exit 1
fi

ln -s /opt/lucee/$jar_folder /opt/lucee/current
