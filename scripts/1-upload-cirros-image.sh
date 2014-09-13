#!/bin/bash -e

. ./openstack-admin-example.rc

rm -rf /tmp/images
mkdir /tmp/images
cd /tmp/images

#wget http://cdn.download.cirros-cloud.net/0.3.2/cirros-0.3.2-x86_64-disk.img
wget http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img

glance image-create --name "cirros-0.3.3-x86_64" \
                    --file cirros-0.3.3-x86_64-disk.img \
                    --disk-format qcow2 \
                    --container-format bare \
                    --is-public True \
                    --progress

cd -
rm -rf /tmp/images
