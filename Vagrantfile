require 'yaml'
require_relative 'yaml_config_validator'

ENV["LC_ALL"] = "en_US.UTF-8"

# Vagrantfile API version.
VAGRANTFILE_VERSION = '2'.freeze

unless Vagrant.has_plugin?('vagrant-triggers')
  puts "'vagrant-triggers' plugin is required"
  puts 'This can be installed by running:'
  puts
  puts ' vagrant plugin install vagrant-triggers'
  puts
  exit
end

configpath = 'config.yml'
if File.exist?(configpath)
  yaml_config = YAML.load_file configpath
  validate_config(yaml_config)
else
  puts "#{configpath} does not exist"
  exit
end

Vagrant.configure(VAGRANTFILE_VERSION) do |config|
  config.vm.box = yaml_config['vagrantbox']['basebox']
  config.vm.define yaml_config['vagrantbox']['name']
  config.vm.hostname = yaml_config['vagrantbox']['name']

  config.vm.network :public_network, bridge: 'enp0s25'

  config.vm.provider 'virtualbox' do |vb|
    vb.name = yaml_config['vagrantbox']['name']
    vb.memory = yaml_config['vagrantbox']['memory']
    vb.cpus = yaml_config['vagrantbox']['cores']
  end

  config.vm.synced_folder yaml_config['webserver']['siteroot']['hostpath'], yaml_config['webserver']['siteroot']['vmpath']

  config.vm.synced_folder yaml_config['webserver']['sitedata']['hostpath'], yaml_config['webserver']['sitedata']['vmpath'],
                          mount_options: ['dmode=777,fmode=777,uid=33,gid=33']

  config.vm.provision 'trigger', option: 'value' do |trigger|
    trigger.fire do
      get_ip_address = %(vagrant ssh #{@machine.name} -c 'ifconfig | grep -oP "inet addr:\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" | grep -oP "\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" | tail -n 2 | head -n 1')
      remoteip = `#{get_ip_address}`
      open('ansible/remoteip.yml', 'w') do |f|
        f.puts "remoteip: #{remoteip}"
      end
    end
  end

  config.vm.provision 'ansible' do |ansible|
    ansible.verbose = 'v'
    ansible.playbook = 'ansible/playbook.yml'
    ansible.extra_vars = configpath
  end

  # config.vm.provider
  # config.vm.provision
  # config.vm.synced_folder
  # config.ssh.forward_env forward host envs to guest

  # config.vm.provision "ansible" do |ansible|
  #   ansible.verbose = "v"
  #   ansible.playbook = "playbook.yml"
  # end
end
