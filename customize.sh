#!/usr/bin/env bash

#
# VNX installation script for Vagrant VMs
# 
# Author: David Fernández (david.fernandez@upm.es)
#
# This file is part of the Virtual Networks over LinuX (VNX) Project distribution. 
# (www: http://www.dit.upm.es/vnx - e-mail: vnx@dit.upm.es) 
# 
# Departamento de Ingenieria de Sistemas Telematicos (DIT)
# Universidad Politecnica de Madrid
# SPAIN
#

# List of additional packages to be installed (space separated list)
ADDITIONAL_PACKAGES='git scapy terminator python3-pip'

echo "---- Installing additional packages"
sudo apt-get -y install $ADDITIONAL_PACKAGES

#
# Customization script. It may use the following environment variables (see others in bootstap.sh):
#
# HNAME   -> hostname
# NEWUSER -> username
# INSTALLDIR -> shared directory where host files are accesible

# Copy ipprefix utilities
cp $INSTALLDIR/ipprefix/* /usr/local/bin/
pip3 install netaddr

#echo "---- Installing latest Wireshark development version (includes 'packet diagram' option):"
##export DEBIAN_FRONTEND=noninteractive
#apt-get -y remove wireshark*
#sudo add-apt-repository ppa:dreibh/ppa
#sudo apt update
##sudo apt -y -o Dpkg::Options::="--force-confold" install wireshark
#DEBIAN_FRONTEND=noninteractive apt -y -o Dpkg::Options::="--force-confold" install wireshark
#usermod -a -G wireshark upm

# Copy tutorials directory
if [ -d "$INSTALLDIR/tutoriales" ]; then
        cp -a $INSTALLDIR/tutoriales /home/$NEWUSER/tutoriales
        chown -R $NEWUSER.$NEWUSER /home/$NEWUSER/tutoriales
fi

# Increase inotify.max_user_instances 
echo "fs.inotify.max_user_instances=2048" >> /etc/sysctl.conf

echo "----"
