# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

# OS_IMAGE = 'debian/buster64'
# OS_IMAGE = 'generic/debian11'
# OS_IMAGE = 'generic/ubuntu2010'
OS_IMAGE = 'generic/ubuntu2004'


NUM_MASTER_NODE = 1
NUM_MINIONS_NODE = 2
NUM_DB_NODE = 0


Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  # Provision Master Nodes
  (1..NUM_MASTER_NODE).each do |i|
    config.vm.define "k8s-master-#{i}", autostart: false do |master|
      master.vm.box = OS_IMAGE
      master.vm.provider :libvirt do |v|
        v.qemu_use_session = false
        v.memory = 2048
        v.cpus= 2
      end
      master.vm.provision "shell", path: "k8s-setup/setup-dns.sh"
      master.vm.provision "shell", inline: "sudo DEBIAN_FRONTEND=noninteractive  apt-get update -y && sudo DEBIAN_FRONTEND=noninteractive  apt-get -y install ansible python3-pip"
      master.vm.provision 'ansible' do |ansible|
        ansible.verbose = true
        ansible.become = true
        ansible.compatibility_mode = 'auto'
        ansible.playbook = 'k8s-setup/k8s-master-setup.yaml'
        ansible.extra_vars = {
          ansible_python_interpreter: '/usr/bin/python3',
        }
      end
    end
  end

  # Provision Worker Nodes
  (1..NUM_MINIONS_NODE).each do |i|
    config.vm.define "k8s-minion-#{i}", autostart: false do |node|
      node.vm.box = OS_IMAGE
      node.vm.provider :libvirt do |v|
        v.qemu_use_session = false
        v.memory = 2048
        v.cpus= 2
        v.storage :file, :size => '50GB',:path => "k8s_minion_#{i}_vdb.img", :allow_existing => true, :type => 'raw'
      end
      node.vm.provision "shell", path: "k8s-setup/setup-dns.sh"
      node.vm.provision "shell", inline: "sudo DEBIAN_FRONTEND=noninteractive  apt-get update -y && sudo DEBIAN_FRONTEND=noninteractive  apt-get -y install ansible python3-pip"
      node.vm.provision "ansible" do |ansible|
        ansible.verbose = true
        ansible.become = true
        ansible.compatibility_mode ="auto"
        ansible.playbook = "k8s-setup/k8s-node-setup.yaml"
        ansible.extra_vars = {
          ansible_python_interpreter: "/usr/bin/python3",
        }
      end
    end
  end

  # Provision DB Nodes
  (1..NUM_DB_NODE).each do |i|
    config.vm.define "db-#{i}" do |lb|
      lb.vm.box = OS_IMAGE
      lb.vm.provider :libvirt do |v|
        v.qemu_use_session = false
        v.memory = 2048
        v.cpus= 2
        v.storage :file, :size => '150GB', :path => 'pgsql_data_disk.img', :allow_existing => true, :type => 'raw'
      end
      lb.vm.provision "shell", path: "k8s-setup/setup-dns.sh"
      lb.vm.provision "shell", inline: "sudo DEBIAN_FRONTEND=noninteractive  apt-get update -y && sudo DEBIAN_FRONTEND=noninteractive  apt-get -y install ansible python3-pip"
      lb.vm.provision 'ansible' do |ansible|
        ansible.verbose = true
        ansible.become = true
        ansible.compatibility_mode = 'auto'
        ansible.playbook = 'k8s-setup/db-setup.yaml'
        ansible.extra_vars = {
          ansible_python_interpreter: '/usr/bin/python3',
        }
      end
    end
  end
end
