#!/bin/bash

apt install memcached python3-memcache

sed -i 's/127.0.0.1/10.0.0.1/g' /etc/memcached.conf
service memcached restart
service memcached status