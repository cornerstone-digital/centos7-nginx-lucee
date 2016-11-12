#!/bin/bash

echo "Updating CentOS Software"
# update OS
yum clean all
yum $YUM_OPTIONS update
yum $YUM_OPTIONS upgrade

# install extra packages
yum $YUM_OPTIONS install epel-release unzip
