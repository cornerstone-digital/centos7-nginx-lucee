#!/bin/bash

echo "Updating CentOS Software"
yum $YUM_OPTIONS update
yum $YUM_OPTIONS upgrade

yum $YUM_OPTIONS install unzip
