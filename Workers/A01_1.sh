#!/bin/bash

sudo -i
echo -e '10.0.0.1\tcontroller' >> /etc/hosts
echo -e '10.0.0.30\tcompute1' >> /etc/hosts
echo -e '10.0.0.40\tcompute2' >> /etc/hosts
echo -e '10.0.0.50\tcompute3' >> /etc/hosts

echo 'nameserver 8.8.8.8' >> /etc/resolv.conf

apt-get update