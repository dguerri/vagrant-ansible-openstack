Setup OpenStack using Libvrt/KVM with Vagrant
==

Foreword
--
I tested these steps on a vanilla Ubuntu Precise (12.04) box running on
Parallels (on OsX).

So, OsX -> Precise Box -> Controller, Network, Compute1 -> Cirros

In this configuration some service on Controller was a bit unstable (I got
some segfaults, I *think* because of nested virtualization).
Using just OsX and Parallers everithing runs smoothly, so please let me know
if you have any issue on your Linux box

Let's get started
--
Clone the vagrant-ansible-openstack and update submodules
```
git clone https://github.com/dguerri/vagrant-ansible-openstack.git
cd vagrant-ansible-openstack/
git submodule init
git submodule update
```

Download and install Vagrant
```
wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb -O /tmp/vagrant_1.7.2_x86_64.deb
sudo dpkg -i /tmp/vagrant_1.7.2_x86_64.deb
```

Install KVM and libvirt
```
sudo apt-get install -y libvirt-bin libvirt-dev qemu qemu-kvm
```

Install vagrant-libvirt provider
```
sudo service libvirt-bin restart
vagrant plugin install vagrant-libvirt
```

Ensure current user is in libvirtd group
```
sudo adduser $USER libvirtd
```

**Re-login** ($USER is now in libvirtd group)


Set environment for Vagrant
```
export VAGRANT_DEFAULT_PROVIDER=libvirt
export BOX_NAME=baremettle/ubuntu-14.04
```

(**optional**) Set the external network interface. This should be the interface your workstation is using to reach the Internet.
So, typically `eth0`. If you leave `EXTERNAL_NETWORK_IF` undefined and your workstation has got more than one interface, Vagrant will ask you to pick one interactively (at least this is what happens with Parallels)
```
export EXTERNAL_NETWORK_IF=eth0
```

(**optional**) Install Vagrnat chachier plugin
```
vagrant plugin install vagrant-cachier
```

Create the OpenStack infrastructure with Ansible
```
cd vagrant-ansible-openstack/
make
```

Demo
--

Install needed OpenStack clients (I am using a virtualenv here)
```
sudo apt-get install -y python-virtualenv
virtualenv .venv
. .venv/bin/activate
sudo apt-get install -y libffi-dev
pip install python-glanceclient python-neutronclient python-novaclient
```

Launch demo
```
make demo
```
