#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$DIR/openstack-demo-example.rc"

if ! (nova keypair-list | grep -q demo-key) ; then
  rm -rf "$DIR/keys"
  mkdir "$DIR/keys"

  ssh-keygen -q -t rsa -N "" -f "$DIR/keys/openstack.key"
  nova keypair-add --pub-key "$DIR/keys/openstack.key.pub" demo-key
fi

echo "Keypair list"
nova keypair-list

echo "Flavor list"
nova flavor-list

echo "Image list"
nova image-list

echo "Network list"
neutron net-list

echo "Secgroup list"
nova secgroup-list

DEMO_NET_ID=$(neutron net-list | awk '/demo-net/ { print $2 }')

echo "Creating a new nova instance"
VM_ID=$(nova boot --poll --flavor m1.tiny --image cirros-0.3.3-x86_64 \
  --nic net-id="$DEMO_NET_ID" \
  --security-group default --key-name demo-key demo-instance1 | \
  awk '/ id / {print $4}')

nova list

echo "Creating a new floating IP"
EXT_NET_ID=$(neutron net-list | awk '/ ext-net / { print $2 }')
FLOATING_IP_ID=$(neutron floatingip-create "$EXT_NET_ID" | awk '/ id / { print $4 }')
sleep 1
FLOATING_IP=$(neutron floatingip-show "$FLOATING_IP_ID" | awk '/floating_ip_address/ { print $4}')
FIXED_IP=$(nova show "$VM_ID" | awk '/demo-net network/ {print $5}')
PORT_ID=$(neutron port-list | grep "$FIXED_IP" | awk '{ print $2 }')

neutron floatingip-associate "$FLOATING_IP_ID" "$PORT_ID"
sleep 1

echo "Opening firewall for SSH and ICMP"
if ! (nova secgroup-list-rules default | grep -q "icmp        | -1"); then
  nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
fi

if ! (nova secgroup-list-rules default | grep -q "tcp         | 22"); then
  nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
fi

echo "Printing console URI"
nova get-vnc-console "$VM_ID" novnc

echo "Your VM floating IP address is: $FLOATING_IP"
echo -e "\n\nEnjoy"
echo "*****************"
echo "ping $FLOATING_IP"
echo "ssh cirros@$FLOATING_IP -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null"
echo -e "*****************\n"
