OpenStack Ansible Roles Umbrella & Demo
=========

**Status**
* [![Build Status](https://travis-ci.org/dguerri/vagrant-ansible-openstack.svg?branch=master)](https://travis-ci.org/dguerri/vagrant-ansible-openstack) on master branch
* [![Build Status](https://travis-ci.org/dguerri/vagrant-ansible-openstack.svg?branch=development)](https://travis-ci.org/dguerri/vagrant-ansible-openstack) on development branch

TL;DR
===
[Step by step guide for Vagrant with KVM/Libvirt](docs/KVM-LibVirt.md)

What is this?
===

This repository contains a demo for the following Ansible roles:

| Status   | Role / Link   |
|--- |--- |
| [![Build Status](https://travis-ci.org/dguerri/openstack-glance.svg?branch=master)](https://travis-ci.org/dguerri/openstack-glance) | [openstack-glance](<https://github.com/dguerri/openstack-glance>) |
| [![Build Status](https://travis-ci.org/dguerri/openstack-horizon.svg?branch=master)](https://travis-ci.org/dguerri/openstack-horizon) | [openstack-horizon](<https://github.com/dguerri/openstack-horizon>) |
| [![Build Status](https://travis-ci.org/dguerri/openstack-keystone.svg?branch=master)](https://travis-ci.org/dguerri/openstack-keystone) | [openstack-keystone](<https://github.com/dguerri/openstack-keystone>) |
| [![Build Status](https://travis-ci.org/dguerri/openstack-neutron_dhcp_agent.svg?branch=master)](https://travis-ci.org/dguerri/openstack-neutron_dhcp_agent) | [openstack-neutron\_dhcp\_agent](<https://github.com/dguerri/openstack-neutron_dhcp_agent>) |
| [![Build Status](https://travis-ci.org/dguerri/openstack-neutron_l3_agent.svg?branch=master)](https://travis-ci.org/dguerri/openstack-neutron_l3_agent) | [openstack-neutron\_l3\_agent](<https://github.com/dguerri/openstack-neutron_l3_agent>) |
| [![Build Status](https://travis-ci.org/dguerri/openstack-neutron_plugin_ml2.svg?branch=master)](https://travis-ci.org/dguerri/openstack-neutron_plugin_ml2) | [openstack-neutron\_plugin\_ml2](<https://github.com/dguerri/openstack-neutron_plugin_ml2>) |
| [![Build Status](https://travis-ci.org/dguerri/openstack-neutron_plugin_openvswitch_agent.svg?branch=master)](https://travis-ci.org/dguerri/openstack-neutron_plugin_openvswitch_agent) | [openstack-neutron\_plugin\_openvswitch\_agent](<https://github.com/dguerri/openstack-neutron_plugin_openvswitch_agent>) |
| [![Build Status](https://travis-ci.org/dguerri/openstack-neutron_server.svg?branch=master)](https://travis-ci.org/dguerri/openstack-neutron_server) | [openstack-neutron\_server](<https://github.com/dguerri/openstack-neutron_server>) |
| [![Build Status](https://travis-ci.org/dguerri/openstack-nova_api.svg?branch=master)](https://travis-ci.org/dguerri/openstack-nova_api) | [openstack-nova\_api](<https://github.com/dguerri/openstack-nova_api>) |
| [![Build Status](https://travis-ci.org/dguerri/openstack-nova_compute.svg?branch=master)](https://travis-ci.org/dguerri/openstack-nova_compute) | [openstack-nova\_compute](<https://github.com/dguerri/openstack-nova_compute>) |
| [![Build Status](https://travis-ci.org/dguerri/openstack-nova_conductor.svg?branch=master)](https://travis-ci.org/dguerri/openstack-nova_conductor) | [openstack-nova\_conductor](<https://github.com/dguerri/openstack-nova_conductor>) |
| [![Build Status](https://travis-ci.org/dguerri/openstack-nova_consoleauth.svg?branch=master)](https://travis-ci.org/dguerri/openstack-nova_consoleauth) | [openstack-nova\_consoleauth](<https://github.com/dguerri/openstack-nova_consoleauth>) |
| [![Build Status](https://travis-ci.org/dguerri/openstack-nova_novncproxy.svg?branch=master)](https://travis-ci.org/dguerri/openstack-nova_novncproxy) | [openstack-nova\_novncproxy](<https://github.com/dguerri/openstack-nova_novncproxy>) |
| [![Build Status](https://travis-ci.org/dguerri/openstack-nova_scheduler.svg?branch=master)](https://travis-ci.org/dguerri/openstack-nova_scheduler) | [openstack-nova\_scheduler](<https://github.com/dguerri/openstack-nova_scheduler>) |

By default this demo builds 4 Trusty 64 VM's using Vagrant and provisions them with Ansible to build a working (yet basic) OpenStack infrastructure.


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
hypervisor, set LIBVIRT_DRIVER to 'qemu' or in the `Vagrantfile` or in the
shell's environment:

```
export LIBVIRT_DRIVER=qemu
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
. .venv/bin/activate
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
