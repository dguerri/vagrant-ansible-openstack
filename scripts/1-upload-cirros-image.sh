#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IMAGE="http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img"

. $DIR/openstack-admin-example.rc

glance image-create --name "cirros-0.3.3-x86_64" \
                    --copy-from $IMAGE \
                    --disk-format qcow2 \
                    --container-format bare \
                    --is-public True \
                    --progress
