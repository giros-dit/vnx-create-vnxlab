# VNX lab virtual machine creation scripts

Author: David Fernández (david.fernandez at upm.es)

## Quick recipe to create VNXLAB2022
From the host:
```bash
# Create the base image with:
cd base-vm
./create-bento-ubuntu-box -g lubuntu -a 64 -d focal -v yes
vagrant destroy
cd ..
# Create the VM:
./create-vm -c VNXSDNLAB.conf
```
From the virtual machine:
```bash
# Customization:
cd customizedir
./customize-from-inside.sh
# Open firefox for the first time to avoid greeting messages later.
```
Back to the host:
```bash
# Clean and halt (password xxxx):
ssh upm@localhost -p 2222 /usr/local/bin/clean_and_halt
# Shrink VM by executing:
./shrink-vm
# Do final configurations and convert to OVA format:
./prepare-ova VNXLAB2022-v1
```

## 1 - Introduction

These scripts were aimed to create Ubuntu based virtual machines with VNX installed to be used for 
laboratory exercises or project demostrations, although they can be also used to create other virtual
machines without VNX. The virtual machines are created using vagrant and VirtualBox.

The creation of the virtual machine is made in two steps. Firstly, a base VM is created by downloading 
the initial raw cloud image (bento/ubuntu-*), upgrading it to the latest package versions and installing 
the GUI and VNX package dependencies. This base VM is registered as a new vagrant box in the system (see 
it with "vagrant box list" command).

During the second step, the final VM is created by cloning the VM created in the first step and installing 
on it the additional packages and executing the customization commands specified in the customize.sh script.

The reason to divide the process in two steps is to accelerate the second step, which is often repeated 
a lot of times during the development. Moving all the slow package installation (mainly the GUI desktop 
package) to the first step, makes the second one much faster.

## 2 - Installation

Requirements: Install Vagrant and VirtualBox
```bash
apt-get install virtualbox vagrant
```
Clone repository:
```bash
git clone https://github.com/giros-dit/vnx-create-vnxlab.git
```
Among others, the following files will be downloaded:
- create-bento-ubuntu-box: script to create the base virtual machine
- create-vm: script to create the final virtual machine
- Vagrantfile: virtual machine vagrant configuration file
- bootstrap.sh: final virtual machine provision script 
- customize.sh: script to include customized code
- shrink-vm: script to shrink virtual machine image before creating the OVA package
- prepare-ova: script to create the OVA (\*.ova) package with the final virtual machine

Customize the installation by:
* Creating a configuration file to specify the values of the basic installation variables:
```bash
DIST: Ubuntu distribution version (trusty, vivid, wily, xenial, zesty)
ARCH: 32 or 64 bits
GUI: graphical interface (gnome, lubuntu, lubuntucore, no)
VNX: install VNX (yes, no)
HNAME: hostname 
NEWUSER: username of main user
NEWPASSWD: password of main user
VMLANG: language (es, en, etc)
MEM: memory assigned to VM in MB (Ex: 2048)
VCPUS: numebre of cores assigned to VM (Ex: 4)

For example:
$ cat VNXLAB.conf 
DIST=focal
ARCH=64
GUI=lubuntu
VNX=yes
HNAME=vnx-vm
NEWUSER=vnx
NEWPASSWD=xxxx
VMLANG=es 
MEM=4096 
VCPUS=2 
```
* Editing customize.sh script and including customization commands to be run from inside the VM during provision (see customize.sh example file)

## 3 - VM creation steps
- Create the base image. For example, to create a 64 bits Ubuntu 20.04 with gnome:
```bash
cd base-vm
./create-bento-ubuntu-box -g gnome -a 64 -d focal -v yes 
vagrant destroy
cd ..
```
  Note: execute "./create-bento-ubuntu-box -h" to see the meaning of arguments.
- Create VM with:
```bash
./create-vm -c VNXLAB.conf
```
  Note: change VNXLAB.conf by the name of your config file.
- Start firefox an close it (to avoid the firefox init page next time it is started)
- Execute the internal customizationi-from-inside.sh script from a VM terminal:
```bash
cd customizedir
./customize-from-inside.sh
```
- Do any other manual configuration you want to do to the VM.
  - Ex: configure the "packet diagram" option in "Edit->Preferences->Appearance->Layout".
- Clean up and halt the VM by executing:
```bash
/usr/local/bin/clean_and_halt
# Note: this script takes some time as it fills the filesystem with zeros to allow better compression.
```
- Shrink VM by executing:
```bash
./shrink-vm
```
- Do final configurations and convert to OVA format:
```bash
./prepare-ova <vm-name>
```
  For example:
```bash
./prepare-ova VNXLAB2022-v1
```
