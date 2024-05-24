#!/bin/bash

apt install rabbitmq-server -y

. /root/service_passwords
rabbitmqctl add_user openstack $RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"