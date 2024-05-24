#!/bin/bash

. /root/service_passwords
apt install neutron-openvswitch-agent -y

crudini --set /etc/neutron/neutron.conf DEFAULT \
transport_url rabbit://openstack:$RABBIT_PASS@controller
crudini --set /etc/neutron/neutron.conf DEFAULT \
auth_strategy keystone
crudini --set /etc/neutron/neutron.conf keystone_authtoken \
www_authenticate_uri http://controller:5000
crudini --set /etc/neutron/neutron.conf keystone_authtoken \
auth_url http://controller:5000
crudini --set /etc/neutron/neutron.conf keystone_authtoken \
memcached_servers controller:11211
crudini --set /etc/neutron/neutron.conf keystone_authtoken \
auth_type password
crudini --set /etc/neutron/neutron.conf keystone_authtoken \
project_domain_name default
crudini --set /etc/neutron/neutron.conf keystone_authtoken \
user_domain_name default
crudini --set /etc/neutron/neutron.conf keystone_authtoken \
project_name service
crudini --set /etc/neutron/neutron.conf keystone_authtoken \
username neutron
crudini --set /etc/neutron/neutron.conf keystone_authtoken \
password $NEUTRON_PASS
crudini --set /etc/neutron/neutron.conf oslo_concurrency \
lock_path /var/lib/neutron/tmp

ovs-vsctl add-br br-vlan
ovs-vsctl add-port br-vlan ens4
crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini \
ovs bridge_mappings physnet1:br-vlan

crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini \
securitygroup enable_security_group true

crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini \
securitygroup firewall_driver openvswitch

crudini --set /etc/nova/nova.conf neutron auth_url \
http://controller:5000
crudini --set /etc/nova/nova.conf neutron auth_type password
crudini --set /etc/nova/nova.conf neutron project_domain_name \
default
crudini --set /etc/nova/nova.conf neutron user_domain_name default
crudini --set /etc/nova/nova.conf neutron region_name RegionOne
crudini --set /etc/nova/nova.conf neutron project_name service
crudini --set /etc/nova/nova.conf neutron username neutron
crudini --set /etc/nova/nova.conf neutron password $NEUTRON_PASS

service nova-compute restart
service neutron-openvswitch-agent restart


