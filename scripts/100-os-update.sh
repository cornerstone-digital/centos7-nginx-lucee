#!/bin/bash

echo "Updating CentOS Software"
# update OS
yum clean all
yum $YUM_OPTIONS update
yum $YUM_OPTIONS upgrade

# install extra packages
# xauth - This fixes "X11 forwarding request failed on channel" issues with SSH commands: https://www.cyberciti.biz/faq/how-to-fix-x11-forwarding-request-failed-on-channel-0/
yum $YUM_OPTIONS install epel-release unzip xauth
