#!/bin/bash -e

. ./openstack-admin-example.rc

FLOATING_IP_START=192.168.0.100
FLOATING_IP_END=192.168.0.250
EXTERNAL_NETWORK_GATEWAY=192.168.0.1
EXTERNAL_NETWORK_CIDR=192.168.0.0/24

neutron net-create ext-net --shared --router:external=True

neutron subnet-create ext-net --name ext-subnet \
  --allocation-pool start=$FLOATING_IP_START,end=$FLOATING_IP_END \
  --disable-dhcp --gateway $EXTERNAL_NETWORK_GATEWAY $EXTERNAL_NETWORK_CIDR
