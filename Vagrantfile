VAGRANT_BOX_NAME = 'trusty64'

Vagrant.configure('2') do |config|
  config.cache.auto_detect = false
  config.cache.enable :apt
  config.cache.scope = :machine

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'playbook.yml'
    ansible.limit = 'all'
    ansible.sudo = true
    ansible.extra_vars = { ansible_ssh_user: 'vagrant' }
  end

  config.vm.define 'controller' do |server|
    server.vm.hostname = 'controller'

    server.vm.box = VAGRANT_BOX_NAME

    # Management network (eth1)
    server.vm.network :private_network, ip: '10.1.2.10'

    %w(parallels virtualbox libvirt vmware_fusion).each do |provider|
      server.vm.provider provider do |c|
        c.memory = 2048
        c.cpus = 4
      end
    end
  end

  config.vm.define 'network' do |server|
    server.vm.hostname = 'network'

    server.vm.box = VAGRANT_BOX_NAME

    # Management network (eth1)
    server.vm.network :private_network, ip: '10.1.2.20'

    # Tunnels network (eth2)
    server.vm.network :private_network, ip: '192.168.129.5'

    # Using eth3 as the External interface
    server.vm.network :public_network

  end

  config.vm.define 'compute1' do |server|
    server.vm.hostname = 'compute1'

    server.vm.box = VAGRANT_BOX_NAME

    # Management network (eth1)
    server.vm.network :private_network, ip: '10.1.2.30'

    # Tunnels network (eth2)
    server.vm.network :private_network, ip: '192.168.129.6'

    # Provider specific settings
    %w(parallels virtualbox libvirt vmware_fusion).each do |provider|
      server.vm.provider provider do |c|
        c.memory = 2048
        c.cpus = 4

        c.vmx['vhv.enable'] = 'TRUE' if provider == 'vmware_fusion'
        c.nested = true if provider == 'libvirt'
        c.customize [
          'set', :id, '--nested-virt', 'on'
        ] if provider == 'parallels'
      end
    end
  end
end
