#!/bin/bash

apt install openstack-dashboard -y

sed -i 's/^OPENSTACK_HOST = "127\.0\.0\.1"/\
OPENSTACK_HOST = "controller"/' \
/etc/openstack-dashboard/local_settings.py

echo "SESSION_ENGINE = 'django.contrib.sessions.backends.cache'" \
>> /etc/openstack-dashboard/local_settings.py
sed -i 's/127.0.0.1:11211/controller:11211/g' \
/etc/openstack-dashboard/local_settings.py

sed -i 's|http://%s/identity/v3|http://%s:5000/v3|' \
/etc/openstack-dashboard/local_settings.py

echo "OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True" >> \
/etc/openstack-dashboard/local_settings.py

echo 'OPENSTACK_API_VERSIONS = {"identity": 3, "image": 2, \
"volume": 3,}' >> /etc/openstack-dashboard/local_settings.py

echo 'OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"' >> \
/etc/openstack-dashboard/local_settings.py

echo 'OPENSTACK_KEYSTONE_DEFAULT_ROLE = "member"' >> \
/etc/openstack-dashboard/local_settings.py

sed -i 's/TIME_ZONE = "UTC"/TIME_ZONE = "America\/Lima"/' \
/etc/openstack-dashboard/local_settings.py

systemctl reload apache2.service