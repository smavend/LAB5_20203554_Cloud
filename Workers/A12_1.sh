#!/bin/bash

apt install nova-compute -y
. /root/service_passwords

crudini --set /etc/nova/nova.conf DEFAULT \
transport_url rabbit://openstack:$RABBIT_PASS@controller

crudini --set /etc/nova/nova.conf \
api auth_strategy keystone

crudini --set /etc/nova/nova.conf \
keystone_authtoken www_authenticate_uri http://controller:5000/

crudini --set /etc/nova/nova.conf \
keystone_authtoken auth_url http://controller:5000/

crudini --set /etc/nova/nova.conf \
keystone_authtoken memcached_servers controller:11211

crudini --set /etc/nova/nova.conf \
keystone_authtoken auth_type password

crudini --set /etc/nova/nova.conf \
keystone_authtoken project_domain_name Default

crudini --set /etc/nova/nova.conf \
keystone_authtoken user_domain_name Default

crudini --set /etc/nova/nova.conf \
keystone_authtoken project_name service

crudini --set /etc/nova/nova.conf \
keystone_authtoken username nova

crudini --set /etc/nova/nova.conf \
keystone_authtoken password $NOVA_PASS

iface=ens3
mgmt_ip=$(ip addr show ${iface} | grep "inet " | awk '{print $2}' | cut -d "/" -f 1)
crudini --set /etc/nova/nova.conf DEFAULT my_ip ${mgmt_ip}

crudini --set /etc/nova/nova.conf vnc enabled true
crudini --set /etc/nova/nova.conf vnc server_listen 0.0.0.0
crudini --set /etc/nova/nova.conf vnc server_proxyclient_address \$my_ip
crudini --set /etc/nova/nova.conf vnc novncproxy_base_url http://controller:6080/vnc_auto.html

crudini --set /etc/nova/nova.conf glance api_servers http://controller:9292
crudini --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp

crudini --set /etc/nova/nova.conf placement region_name RegionOne
crudini --set /etc/nova/nova.conf placement project_domain_name Default
crudini --set /etc/nova/nova.conf placement project_name service
crudini --set /etc/nova/nova.conf placement auth_type password
crudini --set /etc/nova/nova.conf placement user_domain_name Default
crudini --set /etc/nova/nova.conf placement auth_url http://controller:5000/v3
crudini --set /etc/nova/nova.conf placement username placement
crudini --set /etc/nova/nova.conf placement password $PLACEMENT_PASS

service nova-compute restart