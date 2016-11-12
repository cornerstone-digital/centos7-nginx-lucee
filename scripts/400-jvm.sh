#!/bin/sh
#
# This script is designed to install an Oracle JDK install under RHEL/CentOS
# make script executable: chmod u+x 400-jvm.sh

# Abort if not super user
if [[ ! `whoami` = "root" ]]; then
	echo "You must have administrative privileges to run this script"
	echo "Try 'sudo ./400-jvm.sh'"
	exit 1
fi

# Check that the file is a JDK archive
if [[ ! $1 =~ jdk-[0-9]{1}u[0-9]{1,3}.*\.tar\.gz ]]; then
	echo "'$1' doesn't look like a JDK archive."
	echo "The file name should begin 'jdk-XuYY', where X is the version number and YY is the update number."
	echo "Please re-name the file, or download the JDK again and keep the default file name."
	exit 2
fi

# set required variables
JDK_FILE=`echo $1 | sed -r 's/^.*?(jdk-([0-9]{1}u[0-9]{1,3}).*\.tar\.gz)/\1/g'`
JDK_VER=`echo $JDK_FILE | sed -r 's/^jdk-([0-9]{1}u[0-9]{1,3}).*\.tar\.gz/\1/g'`
JDK_NAME=`echo $JDK_VER | sed -r 's/([0-9]{1})u([0-9]{1,3})/jdk1.\1.0_\2/g'`
AUTOREMOVE_JDK_FILE=false

# if we specified a URL, download the file
if [[ $1 =~ ^https?://.*\.tar\.gz$ ]]; then
	echo "Downloading Java JDK..."
	AUTOREMOVE_JDK_FILE=true

	# try downloading with curl
	if type curl >/dev/null 2>&1; then
		curl --silent --junk-session-cookies --insecure --location --header "Cookie: oraclelicense=accept-securebackup-cookie" $1 > $JDK_FILE
	elif type wget >/dev/null 2>&1; then
		wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $1
	else
		echo "You must have either 'curl' or 'wget' installed in order to automatically download the JDK."
		exit 3
	fi
fi

echo "Installing Oracle JVM..."

mkdir -p /opt/lucee/jvm
tar -zxf $JVM_FILE -C /opt/lucee/jvm
chown -R root:root /opt/lucee/jvm
chmod -R 755 /opt/lucee/jvm
ln -s /opt/lucee/jvm/jdk$JDK_VER /opt/lucee/jvm/current
echo $'\nJAVA_HOME="/opt/lucee/jvm/current"' >> /etc/default/tomcat

echo "Tomcat / Lucee Configuration Done, Restarting Tomcat..."
service tomcat restart

# check to see if we need to auto remove the file
if [[ $AUTOREMOVE_JDK_FILE == true ]]; then
	echo "Removing $JDK_FILE..."
	# delete the file we downloaded
	rm -fr $JDK_FILE
fi
exit 0
