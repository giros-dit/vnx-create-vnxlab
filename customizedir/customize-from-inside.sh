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
ADDITIONAL_PACKAGES='openjdk-8-jdk mininet openvswitch-testcontroller'
#ADDITIONAL_PACKAGES=''

# move to the directory where the script is located
cd `dirname $0`
CDIR=$(pwd)

echo "-- Installing additional packages"
sudo apt-get -y install $ADDITIONAL_PACKAGES
sudo systemctl disable openvswitch-testcontroller # Al mininet 2.2.2 no le gusta que este arrancado como demonio

echo "-- Setting JAVA_HOME"
sudo bash -c 'echo -e "#!/bin/sh\nexport JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" > /etc/profile.d/set_java_home.sh'

echo "-- Installing java 7 oracle jdk (needed for OpenVirtex)"
sudo mkdir -p /usr/local/java
cd /usr/local/java
sudo wget --user=java --password=javajavadoo http://idefix.dit.upm.es/download/java/jdk-7u80-linux-x64.tar.gz
sudo tar xfvz jdk-7u80-linux-x64.tar.gz
mkdir -p /home/upm/bin
cd /home/upm
cp customizedir/bin/set-java* bin
chmod +x bin/set-java7 bin/set-java8 


echo "-- Copying VNX rootfs:"
cd /usr/share/vnx/filesystems/
sudo vnx_download_rootfs -r vnx_rootfs_lxc_ubuntu64-20.04-v025-vnxlab.tgz -l -y
sudo ln -s vnx_rootfs_lxc_ubuntu64-20.04-v025-vnxlab rootfs_lxc64-rdor
sudo rm vnx_rootfs_lxc_ubuntu64-20.04-v025-vnxlab.tgz
#sudo vnx_download_rootfs -r vnx_rootfs_lxc_vyos64-1.1.8-v025.tgz -l -y
sudo vnx_download_rootfs -r vnx_rootfs_lxc_vyos64-1.3-v025.tgz -l -y
sudo rm vnx_rootfs_lxc_vyos64-1.3-v025.tgz
    
# Install mininet from source code
#echo "-- Installing mininet:"
#cd ~/
#echo "-- Getting mininet from git:"
#git clone git://github.com/mininet/mininet
#cd mininet/
#echo "-- Checking mininet version 2.2.2:"
#git checkout -b 2.2.2 2.2.2
#echo "-- Calling mininet install:"
#cd ..
#mininet/util/install.sh -a

# Deactivate ipv6
#echo "-- Deactivating ipv6:"
#sudo cat >> /etc/default/grub <<EOF
# Deactivate ipv6
#GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 text
#EOF
#sudo sed -i -e '/^GRUB_CMDLINE_LINUX_DEFAULT=/d' /etc/default/grub
#sudo sed -i -e '/^GRUB_CMDLINE_LINUX/a GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1"' /etc/default/grub
#sudo update-grub


#
# Install openvswitch
#
#sudo apt -y remove openvswitch\*
#sudo apt -y install autoconf libtool
#
#git clone git://github.com/openvswitch/ovs
#cd ovs
#./boot.sh
#./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc
#make
#sudo make install
#
#sudo bash -c "
#cat << EOF > /etc/rc.local
##!/bin/bash 
#export PATH=\\\$PATH:/usr/share/openvswitch/scripts
#ovs-ctl start
#exit 0
#EOF
#"
#
#sudo chmod 0755 /etc/rc.local

# 
# Install Ryu SDN controller
#
# Install RYU (Ubuntu 14.04.3)
# Author: Oleg Slavkin

echo "-- Install RYU"
sudo apt-get -y install python3-ryu

# OLD
#echo "--  Step 1. Install tools"
#sudo apt-get -y install git python-pip python-dev
#
#echo "--  Step 2. Install python packages"
#sudo apt-get -y install python-eventlet python-routes python-webob python-paramiko
#
#echo "--  Step 3. Clone RYU git Repo"
#cd ~/
#git clone --depth=1 https://github.com/osrg/ryu.git
#
#echo "--  Step 4. Install RYU"
#sudo pip install setuptools --upgrade
#cd ryu;
#sudo pip install -r tools/pip-requires
#sudo python ./setup.py install
#
#echo "--  Step 5. Install and Update python packages"
#sudo pip install six --upgrade
#sudo pip install oslo.config msgpack-python
#sudo pip install eventlet --upgrade
#
#echo "--  Step 6. Test ryu-manager"
#ryu-manager --version

echo "--"
echo "-- Install OpenVirteX"
cd /home/upm
git clone https://github.com/OPENNETWORKINGLAB/OpenVirteX.git -b OpenFlow1.3

echo "--"
echo "-- Install Floodlight"
cd /home/upm
wget https://github.com/floodlight/floodlight/archive/v1.2.tar.gz
tar xfvz v1.2.tar.gz
rm v1.2.tar.gz
git clone https://github.com/nbonnand/ovs-toolbox.git

echo "--"
echo "-- FlowManager"
cd /home/upm
git clone https://github.com/martimy/flowmanager

echo "--"
echo "-- Ovs-toolbox"
cd /home/upm
git clone https://github.com/nbonnand/ovs-toolbox.git
cd ovs-toolbox/
sudo ./install_ovstoolbox.sh 

echo "--"
echo "-- Set python3 as default and install pyshark"
echo "--"
sudo apt install -y python-is-python3
sudo pip3 install pyshark

echo "-- Finished"
