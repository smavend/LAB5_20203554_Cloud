#!/bin/bash

wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img

glance image-create --os-username '$OS_USERNAME' --name "cirros" --file ~/cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --visibility=public

# PREGUNTA 4: IMAGE LIST
echo PREGUNTA4
openstack image list










