What the ... is this?
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

This demo builds 3 Trusty 64 VMs using Vagrant and provisions them with Ansible to build a working (yet basic) OpenStack infrastructure.

How can I use this?
===

1) How to get the code
---

_Using git_

Clone this repository and its submodules
```
git clone https://github.com/dguerri/vagrant-ansible-openstack.git
cd vagrant-ansible-openstack/
git submodule init
git submodule update
```

2) Set up Ansible and Vagrant
---

a) Install Ansible using this guide: http://docs.ansible.com/intro_installation.html

b) Set your default Vagrant provider.

For instance:

```
export VAGRANT_DEFAULT_PROVIDER=parallels
```

---
***Note***

If you are using the _Virtualbox_ provider, you must edit `playbook.yml` and add

```
virt_type: qemu
```

to the `openstack-nova_compute` role of `compute1`.

---

c) Download and install an Ubuntu box. For instance:


_Parallels provider_

```
vagrant box add fza/trusty64
```

_Virtualbox, VmWare desktop and Libvirt providers_

```
vagrant box add breqwatr/trusty64
```

See VagrantCloud <https://vagrantcloud.com> for a comprehensive list of vagrant boxes.


d) Set the `BOX_NAME` environment variable as appropriate. `BOX_NAME` defaults to `trusty64`

```
export BOX_NAME="breqwatr/trusty64"
```

e) Install required plugins

```
vagrant plugin install vagrant-cachier
vagrant plugin install vagrant-proxyconf
```

f) If needed, install the additional Vagrnat plugins needed by your hypervisor.

For instance:
```
vagrant plugin install vagrant-parallels
```

g) Install glance, neutron and nova clients (host system)

```
pip install python-glanceclient python-neutronclient python-novaclient
```

3) Run it!
===
```
make
```

4) Enjoy
===

In the `./scripts` directory you will find some bash scripts that can be used to initialise a fresh OpenStack cloud setup.

Execute them in the right order:
```
for script in ./scripts/?-*.sh; do $script; done
```

At the end of this process, just copy-paste the novnc URI in your browser:

```
[...]
+-------+------------------------------------------------------------------------------------+
| Type  | Url                                                                                |
+-------+------------------------------------------------------------------------------------+
| novnc | http://10.211.55.122:6080/vnc_auto.html?token=148015a0-8c2d-43bf-a971-c23808d4a27f |
+-------+------------------------------------------------------------------------------------+
```

In the `./scripts` directory there are also 2 "rc" scripts that can be sourced to manage the OpenStack setup.

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
