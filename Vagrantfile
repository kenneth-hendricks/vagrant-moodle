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


Vagrant.configure(VAGRANTFILE_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  # Create a private network, which allows host-only access to the machine using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.22"

  # Share an additional folder to the guest VM. The first argument is the path on the host to the actual folder.
  # The second argument is the path on the guest to mount the folder.
  config.vm.synced_folder wwwroot_hostpath, wwwroot_vmpath
  config.vm.synced_folder sitedata_hostpath, sitedata_vmpath

  # Define the bootstrap file: A (shell) script that runs after first setup of your box (= provisioning)
  config.vm.provision :shell, path: "vartest.sh", :args => [db_type, db_name, db_user, db_pass, sitedata_hostpath, sitedata_vmpath]
end