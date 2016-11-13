#!/bin/bash

echo "Installing Tomcat 7"
yum $YUM_OPTIONS install tomcat tomcat7-webapps

echo "Configuring Tomcat"

mkdir -p backup
mkdir -p backup/etc
mkdir -p backup/etc/tomcat
mkdir -p backup/usr
#backup default tomcat web.xml
cp /etc/tomcat/web.xml backup/etc/tomcat/web.xml-orig-backup
#copy our web.xml to tomcat directory
cp etc/tomcat/web.xml /etc/tomcat/

#backup default server.xml
cp /etc/tomcat/server.xml backup/etc/tomcat/server.xml-orig-backup
#copy our server.xml to tomcat dir
cp etc/tomcat/server.xml /etc/tomcat/

#backup default catalina.properties
cp /etc/tomcat/catalina.properties backup/etc/tomcat/catalina.properties-orig-backup
#copy our catalina properties
cp etc/tomcat/catalina.properties /etc/tomcat/

cp /usr/share/tomcat/conf/tomcat.conf backup/usr/tomcat.conf

echo "Installing mod_cfml Valve for Automatic Virtual Host Configuration"
if [ -f lib/mod_cfml-valve_v1.1.05.jar ]; then
  cp lib/mod_cfml-valve_v1.1.05.jar /opt/lucee/current/
else
  curl --location -o /opt/lucee/current/mod_cfml-valve_v1.1.05.jar https://raw.githubusercontent.com/utdream/mod_cfml/master/java/mod_cfml-valve_v1.1.05.jar
fi

if [ ! -f /opt/lucee/modcfml-shared-key.txt ]; then
  echo "Generating Random Shared Secret..."
  openssl rand -base64 42 >> /opt/lucee/modcfml-shared-key.txt
  #clean out any base64 chars that might cause a problem
  sed -i "s/[\/\+=]//g" /opt/lucee/modcfml-shared-key.txt
fi

shared_secret=`cat /opt/lucee/modcfml-shared-key.txt`

sed -i "s/SHARED-KEY-HERE/$shared_secret/g" /etc/tomcat/server.xml


echo "Setting Permissions on Lucee Folders"
mkdir -p /usr/share/tomcat/lucee-server
chown -R tomcat:tomcat /usr/share/tomcat/lucee-server
chmod -R 750 /usr/share/tomcat/lucee-server
chown -R tomcat:tomcat /opt/lucee
chmod -R 750 /opt/lucee
chown -R tomcat:tomcat /usr/share/tomcat/webapps/

echo "Setting JVM Max Heap Size to " $JVM_MAX_HEAP_SIZE

sed -i "s/-Xmx128m/-Xmx$JVM_MAX_HEAP_SIZE/g" /usr/share/tomcat/conf/tomcat.conf
