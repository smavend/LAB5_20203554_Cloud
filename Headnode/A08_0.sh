#!/bin/bash

apt install etcd -y

echo 'ETCD_NAME="controller"' >> /etc/default/etcd
echo 'ETCD_DATA_DIR="/var/lib/etcd"' >> /etc/default/etcd
echo 'ETCD_INITIAL_CLUSTER_STATE="new"' >> /etc/default/etcd
echo 'ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"' >> /etc/default/etcd
echo 'ETCD_INITIAL_CLUSTER="controller=http://10.0.0.1:2380"' >> /etc/default/etcd
echo 'ETCD_INITIAL_ADVERTISE_PEER_URLS="http://10.0.0.1:2380"' >> /etc/default/etcd
echo 'ETCD_ADVERTISE_CLIENT_URLS="http://10.0.0.1:2379"' >> /etc/default/etcd
echo 'ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380"' >> /etc/default/etcd
echo 'ETCD_LISTEN_CLIENT_URLS="http://10.0.0.1:2379"' >> /etc/default/etcd

systemctl enable etcd
systemctl restart etcd

systemctl status etcd