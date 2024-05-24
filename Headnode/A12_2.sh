#!/bin/bash

openstack compute service list --service nova-compute
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova

# PREGUNTA 8: COMPUTE COMPONENTS
echo PREGUNTA8
openstack compute service list
