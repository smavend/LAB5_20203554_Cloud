#!/bin/bash

apt install mariadb-server python3-pymysql -y

echo '[mysqld]' > /etc/mysql/mariadb.conf.d/99-openstack.cnf
echo 'bind-address = 10.0.0.1' >> /etc/mysql/mariadb.conf.d/99-openstack.cnf
echo 'default-storage-engine = innodb' >> /etc/mysql/mariadb.conf.d/99-openstack.cnf
echo 'innodb_file_per_table = on' >> /etc/mysql/mariadb.conf.d/99-openstack.cnf
echo 'max_connections = 4096' >> /etc/mysql/mariadb.conf.d/99-openstack.cnf
echo 'collation-server = utf8_general_ci' >> /etc/mysql/mariadb.conf.d/99-openstack.cnf
echo 'character-set-server = utf8' >> /etc/mysql/mariadb.conf.d/99-openstack.cnf

service mysql restart
mysql_secure_installation