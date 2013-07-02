# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = {
  'ci-master-1' => {:ip => '172.16.11.10'},
  'ci-slave-1'  => {:ip => '172.16.11.11'},
  'ci-slave-2'  => {:ip => '172.16.11.12'},
}
node_defaults = {
  :domain => 'internal',
  :memory => 384,
}

Vagrant::VERSION < "1.1.0" and Vagrant::Config.run do |config|
  config.vm.box     = "puppet-precise64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-1204-x64.box"

  config.vm.provision :puppet do |puppet|
    puppet.manifest_file  = "site.pp"
    puppet.manifests_path = "manifests"
    puppet.module_path    = [ "modules", "vendor/modules" ]
    puppet.options = [
      "--verbose", "--summarize",
      "--reports", "store",
      "--hiera_config", "/vagrant/hiera.yaml",
      "--environment", "development",
    ]
  end

  nodes.each do |node_name, node_opts|
    config.vm.define node_name do |node|
      node_opts = node_defaults.merge(node_opts)
      fqdn = "#{node_name}.#{node_opts[:domain]}"

      node.vm.host_name = fqdn

      if node_opts[:ip]
        node.vm.network :hostonly, node_opts[:ip], :netmask => "255.255.255.0"
      end

      modifyvm_args = ['modifyvm', :id]
      modifyvm_args << "--name" << fqdn
      if node_opts[:memory]
        modifyvm_args << "--memory" << node_opts[:memory]
      end
      # Isolate guests from host networking.
      modifyvm_args << "--natdnsproxy1" << "on"
      modifyvm_args << "--natdnshostresolver1" << "on"
      node.vm.customize(modifyvm_args)
    end
  end
end

Vagrant::VERSION >= "1.1.0" and Vagrant.configure("2") do |config|
  config.vm.box     = "puppet-precise64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-1204-x64.box"

  config.vm.provision :puppet do |puppet|
    puppet.manifest_file  = "site.pp"
    puppet.manifests_path = "manifests"
    puppet.module_path    = [ "modules", "vendor/modules" ]
    puppet.options = [
      "--verbose", "--summarize",
      "--reports", "store",
      "--hiera_config", "/vagrant/hiera.yaml",
      "--environment", "development",
    ]
  end

  nodes.each do |node_name, node_opts|
    config.vm.define node_name do |node|
      node_opts = node_defaults.merge(node_opts)
      fqdn = "#{node_name}.#{node_opts[:domain]}"

      node.vm.hostname = fqdn

      if node_opts[:ip]
        node.vm.network(:private_network, :ip => node_opts[:ip])
      end

      node.vm.provider :virtualbox do |vb|
        modifyvm_args = ['modifyvm', :id]
        modifyvm_args << "--name" << fqdn
        if node_opts[:memory]
          modifyvm_args << "--memory" << node_opts[:memory]
        end
        # Isolate guests from host networking.
        modifyvm_args << "--natdnsproxy1" << "on"
        modifyvm_args << "--natdnshostresolver1" << "on"
        vb.customize(modifyvm_args)
      end
    end
  end
end
