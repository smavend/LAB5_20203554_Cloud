#!/bin/bash

timedatectl set-timezone America/Lima
apt install chrony -y

sed -i '/^pool /s/^/# /' /etc/chrony/chrony.conf
echo 'server 0.south-america.pool.ntp.org iburst' >> /etc/chrony/chrony.conf
echo 'server 1.south-america.pool.ntp.org iburst' >> /etc/chrony/chrony.conf
echo 'server 2.south-america.pool.ntp.org iburst' >> /etc/chrony/chrony.conf
echo 'server 3.south-america.pool.ntp.org iburst' >> /etc/chrony/chrony.conf

echo 'allow 10.0.0.0/24' >> /etc/chrony/chrony.conf
service chrony restart
chronyc sources


