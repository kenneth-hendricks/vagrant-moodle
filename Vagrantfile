require 'yaml'
require_relative 'yaml_config_validator'

# Vagrantfile API version.
VAGRANTFILE_VERSION = "2"

if !Vagrant.has_plugin?("vagrant-triggers")
    puts "'vagrant-triggers' plugin is required"
    puts "This can be installed by running:"
    puts
    puts " vagrant plugin install vagrant-triggers"
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
    config.vm.box = yaml_config['boxenvironment']['base']
    config.vm.define yaml_config['boxenvironment']['name']
    config.vm.hostname = yaml_config['boxenvironment']['name']

    config.vm.network :public_network, :bridge => 'enp0s25'

    config.vm.provider "virtualbox" do |vb|
      vb.name = yaml_config['boxenvironment']['name']
      vb.memory = yaml_config['virtualbox']['memory']
      vb.cpus = yaml_config['virtualbox']['cores']
    end

    config.vm.synced_folder yaml_config['siteroot']['hostpath'], yaml_config['siteroot']['vmpath']

    config.vm.synced_folder yaml_config['sitedata']['hostpath'], yaml_config['sitedata']['vmpath'],
                            mount_options: ['dmode=777,fmode=777']


    config.vm.provision "trigger", :option => "value" do |trigger|
        trigger.fire do
            get_ip_address = %Q(vagrant ssh #{@machine.name} -c 'ifconfig | grep -oP "inet addr:\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" | grep -oP "\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" | tail -n 2 | head -n 1')
            remoteip = `#{get_ip_address}`
            open('ansible/remoteip.yml', 'w') { |f|
              f.puts "remoteip: #{remoteip}"
            }
        end
    end

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "ansible/playbook.yml"
    ansible.extra_vars = configpath
  end

  #config.vm.provider
  #config.vm.provision
  #config.vm.synced_folder
  #config.ssh.forward_env forward host envs to guest

  # config.vm.provision "ansible" do |ansible|
  #   ansible.verbose = "v"
  #   ansible.playbook = "playbook.yml"
  # end

end
