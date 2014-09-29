#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. $DIR/openstack-admin-example.rc

rm -rf $DIR/images
mkdir $DIR/images
cd $DIR/images

#wget http://cdn.download.cirros-cloud.net/0.3.2/cirros-0.3.2-x86_64-disk.img
wget http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img

glance image-create --name "cirros-0.3.3-x86_64" \
                    --file cirros-0.3.3-x86_64-disk.img \
                    --disk-format qcow2 \
                    --container-format bare \
                    --is-public True \
                    --progress

cd -
rm -rf $DIR/images
