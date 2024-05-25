#!/bin/bash

echo "nameserver 8.8.8.8" >> /etc/resolv.conf
apt-get install crudini -y
add-apt-repository cloud-archive:victoria -y
