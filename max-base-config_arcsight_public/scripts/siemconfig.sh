#!/bin/bash

## siemconfig.sh
## kvice 9/12/2018
## Configures a CentOS Linux host with xrdp, Mate, and ArcSight EMS
## Takes params: admin username $1, password $2

# Set SELinux enforcement to permissive
setenforce 0

# Apply all available updates, omit Azure agent to prevent script failure
yum update -y --exclude=WALinuxAgent

# Install foundation packages
yum install epel-release -y
yum install byobu -y
#yum groups install "Server with GUI" -y
#yum groups install "MATE Desktop" -y
yum -y --enablerepo epel install xrdp tigervnc-server
yum -y --enablerepo epel install mate-desktop
#yum -y install mailx tcpdump

# Set GUI autostart
systemctl isolate graphical.target
systemctl set-default graphical.target

# Configure SELinux for xrdp
chcon --type=bin_t /usr/sbin/xrdp
chcon --type=bin_t /usr/sbin/xrdp-sesman

# Start and enable xrdp
service xrdp start
systemctl enable xrdp.service

# Set up Mate desktop for builtin admin user
#echo "exec mate-session" > ~/.Xclients
#chmod 700 ~/.Xclients

# Set up Mate desktop for all users
#echo "exec mate-session" > /etc/skel/.Xclients
#chmod 700 /etc/skel/.Xclients

# Restart xrdp
service xrdp restart

# Start GUI
systemctl start graphical.target

# Update time zone
yum -y update tzdata
timedatectl set-timezone America/Los_Angeles

##### FOLLOWING REMMED OUT UNTIL ARCSIGHT INSTALL SCRIPTS ARE AVAILABLE #####

## Install ArcSight EMS
# From https://www.slideshare.net/Protect724/esm-install-guide60c

# Create arcsight user, use passed param $1 for raw password (NOT WORKING)
#groupadd arcsight
#username="arcsight"
#pass=$(perl -e 'print crypt($ARGV[0], "password")' $2)
#useradd -c “arcsight_software_owner” -g arcsight -d -p $pass $username
#/home/arcsight -m -s /bin/bash arcsight

# Mount data disk /dev/sdc1 as /arcsight
parted /dev/sdc mklabel msdos
parted -s -a optimal /dev/sdc mkpart primary xfs 1MiB 1000MiB
mkfs.xfs -L /arcsight -q /dev/sdc1
mkdir /arcsight
mount /dev/sdc1 /arcsight
cp /etc/fstab /etc/fstab.old
echo -e "/dev/sdc1 /arcsight xfs defaults 0 0" >> /etc/fstab

# Install dependencies
#yum -y groupinstall "Web Server", "Compatibility Libraries", "Development Tools"
#yum -y install pam

# Disable IPv6 per https://community.softwaregrp.com/t5/ArcSight-User-Discussions/Fresh-ESM-Installation-stops-at-quot-Set-up-ArcSight-Storage/td-p/1519539
#sysctl -w net.ipv6.conf.default.disable_ipv6=1
#sysctl -w net.ipv6.conf.all.disable_ipv6=1

# Create install folder, chown to arcsight
#mkdir -m777 arcsight_install
#cd arcsight_install
#tar xvf ArcSightESMSuite-7.0.0.xxxx.1.tar
#chown -R arcsight:arcsight .

# Run prepare_system.sh
#cd Tools
#./prepare_system.sh

# Install ESM as arcsight user
#su arcsight
#./ArcSightESMSuite.bin -i console



# Start services
# /opt/arcsight/manager/bin/setup_services.sh


# FINAL
