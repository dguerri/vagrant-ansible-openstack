What is this?
===

This repository contains a demo for the following Ansible roles:

* `openstack-glance` (<https://github.com/dguerri/openstack-glance>)
* `openstack-horizon` (<https://github.com/dguerri/openstack-horizon>)
* `openstack-keystone` (<https://github.com/dguerri/openstack-keystone>)
* `openstack-neutron_dhcp_agent` (<https://github.com/dguerri/openstack-neutron_dhcp_agent>)
* `openstack-neutron_l3_agent` (<https://github.com/dguerri/openstack-neutron_l3_agent>)
* `openstack-neutron_plugin_ml2` (<https://github.com/dguerri/openstack-neutron_plugin_ml2>)
* `openstack-neutron_plugin_openvswitch_agent` (<https://github.com/dguerri/openstack-neutron_plugin_openvswitch_agent>)
* `openstack-neutron_server` (<https://github.com/dguerri/openstack-neutron_server>)
* `openstack-nova_api` (<https://github.com/dguerri/openstack-nova_api>)
* `openstack-nova_compute` (<https://github.com/dguerri/openstack-nova_compute>)
* `openstack-nova_conductor` (<https://github.com/dguerri/openstack-nova_conductor>)
* `openstack-nova_consoleauth` (<https://github.com/dguerri/openstack-nova_consoleauth>)
* `openstack-nova_novncproxy` (<https://github.com/dguerri/openstack-nova_novncproxy>)
* `openstack-nova_scheduler` (<https://github.com/dguerri/openstack-nova_scheduler>)

By default this demo builds 4 Trusty 64 VMs using Vagrant and provisions them with Ansible to build a working (yet basic) OpenStack infrastructure.


Architecture - Network diagram
---

```
    +----------------------Vagrant-Workstation----------------------+
    |                                                               |
    |  +---------------------------------------------------------+  |
    |  |                Management - 10.1.2.0/24                 |  |
    |  +---------------------------------------------------------+  |
    |        |             |             |                 |        |
    |        |.10          |.20          |.30              |.30+N-1 |
    |  +-----------+ +-----------+ +-----------+     +-----------+  |
    |  |           | |           | |           |     |           |  |
    |  |Controller | |  Network  | | Compute1  |. . .| ComputeN  |  |
    |  |           | |           | |           |     |           |  |
    |  +-----------+ +-----------+ +-----------+     +-----------+  |
    |                   |     |.5        |.6               | .6+N-1 |
    |                   |     |          |                 |        |
    |              +----+  +-------------------------------------+  |
    |              |       |     Tunnels - 192.168.129.0/24      |  |
    |              |       +-------------------------------------+  |
    |  +----------------------------------------------+             |
    |  |  External (Bridged to workstation network)   |             |
    |  +----------------------------------------------+             |
    +----------|----------------------------------------------------+
               |                           +------+
            +-----+                        |      +------+------+
          +-|-----|-+                      ++                   |
          | ||   || |-----------------------|    Internet     +-+
          +-|-----|-+                       |                 |
            +-----+                         +-----------+     |
        Router (+ DHCP)                                 +-----+

```
*(Drawn with Monodraw alpha, courtesy of Milen Dzhumerov)*


Architecture - Services distribution
---

**Controller**

* NTPd
* MySQL
* RabbitMQ server
* Keystone
* Glance
* Nova Conductor
* Nova ConsoleAuth
* Nova noVNC Proxy
* Nova Scheduler
* Nova API
* Neutron Server
* Neutron Plugin Modular Layer 2 (ML2)
* Horizon

**Network**

* NTPd
* Neutron Plugin Modular Layer 2 (ML2)
* Neutron Plugin OpenVSwitch agent
* Neutron Plugin Layer 3 agent
* Neutron Plugin DHCP agent

**Compute nodes**

* NTPd
* Neutron Plugin Modular Layer 2 (ML2)
* Neutron Plugin OpenVSwitch agent
* Nova Compute


How can I use this demo?
===

1) Get the code
---

***Using git***

Clone this repository and its submodules
```
git clone https://github.com/dguerri/vagrant-ansible-openstack.git
cd vagrant-ansible-openstack/
git submodule init
git submodule update
```

2) Set up Ansible and Vagrant
---

***Install Ansible***

http://docs.ansible.com/intro_installation.html


***Install Vagrant***

https://www.vagrantup.com/downloads.html


***Set your default Vagrant provider***

For instance:

```
export VAGRANT_DEFAULT_PROVIDER=parallels
```

_Note_

_Virtualbox_ doesn't support nested virtualization. If you are using this
hypervisor, edit `group_vars/all.yml` and set:

```
[...]
NOVA_VIRT_TYPE: "qemu"
```

or you will not be able to spawn virtual machines in your cloud.


***Download and install an Ubuntu box***

See VagrantCloud <https://vagrantcloud.com> for a comprehensive list of vagrant boxes.
For instance:

- Parallels provider

```
vagrant box add fza/trusty64
```

- Virtualbox, VmWare desktop and Libvirt providers

```
vagrant box add breqwatr/trusty64
```

***Set `BOX_NAME` environment variable as appropriate***

`BOX_NAME` defaults to `trusty64`. To use a different box:

```
export BOX_NAME="breqwatr/trusty64"
```

***Install required plugins***

```
vagrant plugin install vagrant-cachier
```

If you are not using _Virtualbox_, install additional Vagrant plugins needed by your hypervisor.

For instance:
```
vagrant plugin install vagrant-parallels
```

***Install core OpenStack clients***

Install at least glance, neutron and nova clients on your workstation

For instance, using a virtual environment:

```
virtualenv .venv
.venv/bin/activate
pip install python-glanceclient python-neutronclient python-novaclient
```

3) Run it!
===
By default 2 compute nodes are created.
To spawn a different number of compute nodes, export the environment variable `COMPUTE_NODES`.

For instance:

```
export COMPUTE_NODES=3
```

When ready, just issue:
```
make
```

4) Enjoy
===

In the `./demo` directory you will find an inventory and a playbook that can be used to initialize a fresh OpenStack Cloud setup and create a demo virtual machine.

Run ansible with:
```
ansible-playbook -i demo/inventory demo/playbook.yml
```

Alternatively, just run:
```
make demo
```

At the end of the play some debug messages are displayed about the newly created VM:

```
[...]
TASK: [Add the floating IP to demo-instance1] *********************************
skipping: [localhost]

TASK: [Get floating IP address] ***********************************************
ok: [localhost]

TASK: [Get noVNC console] *****************************************************
ok: [localhost]

TASK: [Message1] **************************************************************
ok: [localhost] => {
    "msg": "Your VM floating IP address is 192.168.0.101"
}

TASK: [Message2] **************************************************************
ok: [localhost] => {
    "msg": "ssh cirros@192.168.0.101 -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null"
}

TASK: [Message3] **************************************************************
ok: [localhost] => {
    "msg": "noVNC console http://10.1.2.10:6080/vnc_auto.html?token=1ed6ad07-eb5d-4810-ac79-f1fe8652ae69"
}

PLAY RECAP ********************************************************************
localhost                  : ok=21   changed=0    unreachable=0    failed=0
```

In the `./script` directory there are 2 ".rc" scripts that can be sourced to manage the OpenStack setup.

Source one of them:
```
. scripts/openstack-admin-example.rc
```
And use OpenStack python clients as usual
```
# keystone tenant-list
+----------------------------------+---------+---------+
|                id                |   name  | enabled |
+----------------------------------+---------+---------+
| c64f42559fbb40078ef8900023bbe5a8 |  admin  |   True  |
| 198aad268c0242159b033bc24f3fb08a |   demo  |   True  |
| d16c66bed5e24e95baca607011a0119c | service |   True  |
+----------------------------------+---------+---------+
```

Last, Horizon is available at:

```
http://10.1.2.10/horizon/
```

Where `10.1.2.10` is the address of controller node.
