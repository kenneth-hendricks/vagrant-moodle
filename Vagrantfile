require 'yaml'
require_relative 'yaml_config_validator'



# Vagrantfile API version.
VAGRANTFILE_VERSION = "2"

configpath = 'config.yml'
if File.exist?(configpath)
  yaml_config = YAML.load_file configpath
  validate_config(yaml_config)
else
  puts "#{configpath} does not exist"
  exit
end

Vagrant.configure(VAGRANTFILE_VERSION) do |config|

  config.vm.box = yaml_config['boxenvironment']['base']
  config.vm.define yaml_config['boxenvironment']['name']
  config.vm.hostname = yaml_config['boxenvironment']['name']

  config.vm.network "private_network", type: "dhcp"

  config.vm.provider "virtualbox" do |vb|
    vb.name = yaml_config['boxenvironment']['name']
    vb.memory = yaml_config['virtualbox']['memory']
    vb.cpus = yaml_config['virtualbox']['cores']
  end

  config.vm.synced_folder yaml_config['siteroot']['hostpath'],
                          yaml_config['siteroot']['vmpath']

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "ansible/playbook.yml"
    ansible.extra_vars = configpath
  end

  #config.vm.post_up_message = "You have made it!"
  #config.vm.provider
  #config.vm.provision
  #config.vm.synced_folder
  #config.ssh.forward_env forward host envs to guest

  # config.vm.provision "ansible" do |ansible|
  #   ansible.verbose = "v"
  #   ansible.playbook = "playbook.yml"
  # end
  
end
