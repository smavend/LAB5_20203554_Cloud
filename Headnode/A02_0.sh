#!/bin/bash

echo 'export ADMIN_PASS='$(openssl rand -hex 16) > ~/service_passwords
echo 'export CINDER_DBPASS='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export CINDER_PASS='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export DASH_DBPASS='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export DEMO_PASS='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export GLANCE_DBPASS='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export GLANCE_PASS='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export KEYSTONE_DBPASS='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export METADATA_SECRET='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export NEUTRON_DBPASS='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export NEUTRON_PASS='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export NOVA_DBPASS='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export NOVA_PASS='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export PLACEMENT_PASS='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export PLACEMENT_DBPASS='$(openssl rand -hex 16) >> ~/service_passwords
echo 'export RABBIT_PASS='$(openssl rand -hex 16) >> ~/service_passwords

scp ~/service_passwords ubuntu@compute1:/home/ubuntu
scp ~/service_passwords ubuntu@compute2:/home/ubuntu
scp ~/service_passwords ubuntu@compute3:/home/ubuntu