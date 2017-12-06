# -*- mode: ruby -*-
# vi: set ft=ruby :
# rubocop:disable BlockLength

Kernel.load(File.expand_path('./plugins/piwik.rb', File.dirname(__FILE__)))

config_file = File.expand_path('./config.rb', File.dirname(__FILE__))
config      = Piwik::Config.new(config_file)
vm          = Piwik::DevVM.new(config)

vm.check_requirements!

chef_run_list = ['recipe[piwik]']

Vagrant.configure('2') do |global|
  if Vagrant.has_plugin?('vagrant-hostmanager')
    global.hostmanager.enabled           = true
    global.hostmanager.ignore_private_ip = false
    global.hostmanager.include_offline   = true

    # /etc/hosts is not writable on NixOS
    global.hostmanager.manage_host = !File.exist?('/etc/NIXOS')
  end

  global.ssh.forward_agent = true

  global.vm.define config.vm_name do |piwik|
    piwik.vm.box      = 'threatstack/ubuntu-14.04-amd64'
    piwik.vm.hostname = config.server_name

    piwik.vm.network 'private_network', ip: config.vm_ip

    piwik.vm.synced_folder config.source,
                           '/srv/piwik',
                           owner: 'vagrant',
                           group: 'vagrant'

    if File.directory?(File.expand_path(config.source_device_detector))
      piwik.vm.synced_folder config.source_device_detector,
                             '/srv/device-detector',
                             owner: 'vagrant',
                             group: 'vagrant'

      chef_run_list << 'recipe[piwik-device-detector]'
    end

    if config.plugin_glob && config.plugin_pattern
      Dir.glob(config.plugin_glob).each do |glob|
        plugin = config.plugin_pattern.match(File.basename(glob))[1]

        continue unless plugin

        piwik.vm.synced_folder glob,
                               "/srv/piwik/plugins/#{plugin}",
                               owner: 'vagrant',
                               group: 'vagrant'
      end
    end

    piwik.vm.provider 'virtualbox' do |vb|
      vb.customize ['modifyvm', :id, '--name', config.vm_name]

      vb.cpus   = 2
      vb.gui    = false
      vb.memory = config.vm_type == 'minimal' ? 2048 : 4096
    end

    piwik.vm.provision 'bootstrap',
                       type: 'shell',
                       path: 'bootstrap.sh'

    piwik.vm.provision 'chef_solo' do |chef|
      chef.cookbooks_path = %w[cookbooks berks-cookbooks]
      chef.run_list = chef_run_list
    end
  end
end
