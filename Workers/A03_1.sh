#!/bin/bash

timedatectl set-timezone America/Lima
apt install chrony -y

sed -i '/^pool /s/^/# /' /etc/chrony/chrony.conf
echo 'server controller iburst' >> /etc/chrony/chrony.conf

service chrony restart
chronyc sources