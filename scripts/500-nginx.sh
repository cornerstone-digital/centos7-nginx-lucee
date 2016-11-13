#!/bin/bash
# Default: WEB_ROOT="/web"

echo "Installing nginx"
yum $YUM_OPTIONS install nginx
echo "Adding lucee nginx configuration files"
cp etc/nginx/conf.d/lucee-global.conf /etc/nginx/conf.d/lucee-global.conf
cp etc/nginx/lucee.conf /etc/nginx/lucee.conf
cp etc/nginx/lucee-proxy.conf /etc/nginx/lucee-proxy.conf
# create Ubuntu style nginx site folders
mkdir -p /etc/nginx/sites-enabled
mkdir -p /etc/nginx/sites-available
echo "Adding sites-enabled support"
# add the sites-enabled config option
sed -i '\@include /etc/nginx/conf\.d/\*\.conf;@a 	include /etc/nginx/sites-enabled/\*;' /etc/nginx/nginx.conf
echo "Disabling nginx default site"
# disable default site, by commenting out the listen on port 80
sed -i -E 's/\blisten\s+(\[::\]:)?80/#&/' /etc/nginx/nginx.conf

echo "Configuring modcfml shared secret in nginx"
shared_secret=`cat /opt/lucee/modcfml-shared-key.txt`
sed -i "s/SHARED-KEY-HERE/$shared_secret/g" /etc/nginx/lucee-proxy.conf

echo "Creating web root and default sites here: " $WEB_ROOT
mkdir -p $WEB_ROOT
mkdir -p $WEB_ROOT/default
mkdir -p $WEB_ROOT/default/wwwroot
mkdir -p $WEB_ROOT/example.com
mkdir -p $WEB_ROOT/example.com/wwwroot

echo "Creating a default index.html"
echo "<!doctype html><html><body><h1>Hello</h1></body></html>" > $WEB_ROOT/default/wwwroot/index.html

#add tomcat and nginx users to apache group so it can read files
usermod -aG apache tomcat
usermod -aG apache nginx

#set the web directory permissions
chown -R root:apache $WEB_ROOT
chmod -R 750 $WEB_ROOT


echo "Adding Default and Example Site to nginx"
cp etc/nginx/sites-available/*.conf /etc/nginx/sites-available/
echo "Adding our default site"
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf



service nginx restart
