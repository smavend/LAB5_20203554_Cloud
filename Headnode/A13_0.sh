#!/bin/bash

. /root/service_passwords
mysql -e "CREATE DATABASE neutron;"

mysql -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '$NEUTRON_DBPASS';"
mysql -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '$NEUTRON_DBPASS';"

. ~/env-scripts/admin-openrc

openstack user create --domain default --password $NEUTRON_PASS neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network

openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696

apt install neutron-server neutron-plugin-ml2 \
neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent \
neutron-openvswitch-agent -y

crudini --set /etc/neutron/neutron.conf database \
connection mysql+pymysql://neutron:$NEUTRON_DBPASS@controller/neutron

crudini --set /etc/neutron/neutron.conf DEFAULT \
transport_url rabbit://openstack:$RABBIT_PASS@controller

crudini --set /etc/neutron/neutron.conf DEFAULT core_plugin ml2
crudini --set /etc/neutron/neutron.conf DEFAULT service_plugins router
crudini --set /etc/neutron/neutron.conf DEFAULT allow_overlapping_ips true
crudini --set /etc/neutron/neutron.conf DEFAULT auth_strategy keystone
crudini --set /etc/neutron/neutron.conf keystone_authtoken www_authenticate_uri http://controller:5000
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_url http://controller:5000
crudini --set /etc/neutron/neutron.conf keystone_authtoken memcached_servers controller:11211
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_type password
crudini --set /etc/neutron/neutron.conf keystone_authtoken project_domain_name default
crudini --set /etc/neutron/neutron.conf keystone_authtoken user_domain_name default
crudini --set /etc/neutron/neutron.conf keystone_authtoken project_name service
crudini --set /etc/neutron/neutron.conf keystone_authtoken username neutron
crudini --set /etc/neutron/neutron.conf keystone_authtoken password $NEUTRON_PASS
crudini --set /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_status_changes true
crudini --set /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_data_changes true
crudini --set /etc/neutron/neutron.conf nova auth_url http://controller:5000
crudini --set /etc/neutron/neutron.conf nova auth_type password
crudini --set /etc/neutron/neutron.conf nova project_domain_name default
crudini --set /etc/neutron/neutron.conf nova user_domain_name default
crudini --set /etc/neutron/neutron.conf nova region_name RegionOne
crudini --set /etc/neutron/neutron.conf nova project_name service
crudini --set /etc/neutron/neutron.conf nova username nova
crudini --set /etc/neutron/neutron.conf nova password $NOVA_PASS
crudini --set /etc/neutron/neutron.conf oslo_concurrency lock_path /var/lib/neutron/tmp

crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 type_drivers flat,vlan
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 mechanism_drivers openvswitch
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 tenant_network_types vlan
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_flat flat_networks physnet0
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_vlan network_vlan_ranges physnet1:11:900
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 extension_drivers port_security
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_ipset true

ovs-vsctl add-br br-provider
ovs-vsctl add-br br-vlan
ovs-vsctl add-port br-vlan ens5
crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini \
ovs bridge_mappings physnet0:br-provider,physnet1:br-vlan

crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini \
securitygroup enable_security_group true

crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini \
securitygroup firewall_driver openvswitch

crudini --set /etc/neutron/l3_agent.ini DEFAULT \
interface_driver openvswitch

crudini --set /etc/neutron/dhcp_agent.ini DEFAULT \
interface_driver openvswitch
crudini --set /etc/neutron/dhcp_agent.ini DEFAULT \
dhcp_driver neutron.agent.linux.dhcp.Dnsmasq
crudini --set /etc/neutron/dhcp_agent.ini DEFAULT \
enable_isolated_metadata true

crudini --set /etc/neutron/metadata_agent.ini DEFAULT \
nova_metadata_host controller
crudini --set /etc/neutron/metadata_agent.ini DEFAULT \
metadata_proxy_shared_secret $METADATA_SECRET

crudini --set /etc/nova/nova.conf neutron auth_url http://controller:5000
crudini --set /etc/nova/nova.conf neutron auth_type password
crudini --set /etc/nova/nova.conf neutron project_domain_name default
crudini --set /etc/nova/nova.conf neutron user_domain_name default
crudini --set /etc/nova/nova.conf neutron region_name RegionOne
crudini --set /etc/nova/nova.conf neutron project_name service
crudini --set /etc/nova/nova.conf neutron username neutron
crudini --set /etc/nova/nova.conf neutron password $NEUTRON_PASS
crudini --set /etc/nova/nova.conf neutron service_metadata_proxy true
crudini --set /etc/nova/nova.conf neutron metadata_proxy_shared_secret $METADATA_SECRET

su -s /bin/sh -c "neutron-db-manage --config-file \
/etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini \
upgrade head" neutron

service nova-api restart

service neutron-server restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
service neutron-l3-agent restart
service neutron-openvswitch-agent restart

openstack network agent list

openstack network create --share --external \
--provider-physical-network physnet0 \
--provider-network-type flat external
openstack subnet create --network external \
--allocation-pool start=172.20.15.2,end=172.20.15.254 \
--dns-nameserver 8.8.8.8 --gateway 172.20.15.1 \
--subnet-range 172.20.15.0/24 external_subnet