# -*- mode: ruby -*-
# vi: set ft=ruby :

#for config
require 'yaml'

# Vagrantfile API version.
VAGRANTFILE_VERSION = "2"

config = YAML.load_file 'config.yml'

db_type = config['db']['type']
db_name = config['db']['name']
db_user = config['db']['user']
db_pass = config['db']['pass']
wwwroot_hostpath = config['wwwroot']['hostpath']
wwwroot_vmpath = config['wwwroot']['vmpath']
sitedata_hostpath = config['sitedata']['hostpath']
sitedata_vmpath = config['sitedata']['vmpath']
wwwroot_git_url = config['wwwroot']['git']['url'];
wwwroot_git_branch = config['wwwroot']['git']['branch'];

if !Vagrant.has_plugin?("vagrant-triggers")
    puts "'vagrant-triggers' plugin is required"
    puts "This can be installed by running:"
    puts
    puts " vagrant plugin install vagrant-triggers"
    puts
    exit
end


Vagrant.configure(VAGRANTFILE_VERSION) do |config|

  # Initial vagrant box to build off of.
  config.vm.box = "ubuntu/trusty64"

  # Create a private network, which allows host-only access to the machine using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.22"

  # Site data and wwwroot folders.
  config.vm.synced_folder wwwroot_hostpath, wwwroot_vmpath

  # Define the bootstrap file: A (shell) script that runs after first setup of your box (= provisioning)
  config.vm.provision :shell, path: "bootstrap.sh", :args => [db_type, db_name, db_user, db_pass, wwwroot_hostpath, wwwroot_vmpath, sitedata_hostpath, sitedata_vmpath]

  config.vm.provision "trigger", :option => "value" do |trigger|
    trigger.fire do
    run "./git.sh #{wwwroot_hostpath} #{wwwroot_git_url} #{wwwroot_git_branch}"
    end
  end


end
