#!/bin/bash

. /root/service_passwords

mysql -e "CREATE DATABASE keystone;"
mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$KEYSTONE_DBPASS';"
mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$KEYSTONE_DBPASS';"

apt install keystone -y

crudini --set /etc/keystone/keystone.conf database connection mysql+pymysql://keystone:$KEYSTONE_DBPASS@controller/keystone
crudini --set /etc/keystone/keystone.conf token provider fernet

su -s /bin/sh -c "keystone-manage db_sync" keystone

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

keystone-manage bootstrap --bootstrap-password $ADMIN_PASS \
--bootstrap-admin-url http://controller:5000/v3/ \
--bootstrap-internal-url http://controller:5000/v3/ \
--bootstrap-public-url http://controller:5000/v3/ \
--bootstrap-region-id RegionOne

echo 'ServerName controller' >> /etc/apache2/apache2.conf
systemctl restart apache2
mkdir ~/env-scripts

echo 'export OS_USERNAME=admin' > ~/env-scripts/admin-openrc
echo "export OS_PASSWORD=$ADMIN_PASS" >> ~/env-scripts/admin-openrc
echo 'export OS_PROJECT_NAME=admin' >> ~/env-scripts/admin-openrc
echo 'export OS_USER_DOMAIN_NAME=Default' >> ~/env-scripts/admin-openrc
echo 'export OS_PROJECT_DOMAIN_NAME=Default' >> ~/env-scripts/admin-openrc
echo 'export OS_AUTH_URL=http://controller:5000/v3' >> ~/env-scripts/admin-openrc
echo 'export OS_IDENTITY_API_VERSION=3' >> ~/env-scripts/admin-openrc
echo 'export OS_IMAGE_API_VERSION=2' >> ~/env-scripts/admin-openrc

. ~/env-scripts/admin-openrc

# PREGUNTA 1: USER LIST
echo PREGUNTA1
openstack user list