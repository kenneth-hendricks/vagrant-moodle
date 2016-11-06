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
siteroot_hostpath = config['siteroot']['hostpath']
siteroot_vmpath = config['siteroot']['vmpath']
sitedata_hostpath = config['sitedata']['hostpath']
sitedata_vmpath = config['sitedata']['vmpath']
siteroot_git_url = config['siteroot']['git']['url'];
siteroot_git_branch = config['siteroot']['git']['branch'];
wwwroot = '192.168.33.22';
site_name_full = config['site']['name']['full'];
site_name_short = config['site']['name']['short'];
site_admin_user = config['site']['admin']['user'];
site_admin_pass = config['site']['admin']['pass'];
site_admin_email = config['site']['admin']['email'];

puts db_type;
puts db_name;
puts db_user;
puts db_pass;
puts siteroot_hostpath;
puts siteroot_vmpath;
puts sitedata_hostpath;
puts sitedata_vmpath;
puts siteroot_git_url;
puts siteroot_git_branch;
puts wwwroot;
puts site_name_full;
puts site_name_short;
puts site_admin_user;
puts site_admin_pass;
puts site_admin_email;


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
  config.vm.network "private_network", ip: wwwroot

  # Site data and siteroot folders.
  config.vm.synced_folder siteroot_hostpath, siteroot_vmpath

  config.vm.provision "trigger", :option => "value" do |trigger|
    trigger.fire do
    run "./git.sh #{siteroot_hostpath} #{siteroot_git_url} #{siteroot_git_branch}"
    end
  end

  # Define the bootstrap file: A (shell) script that runs after first setup of your box (= provisioning)
  config.vm.provision :shell, path: "bootstrap.sh", :args => [db_type, db_name, db_user, db_pass, siteroot_hostpath, siteroot_vmpath, sitedata_hostpath, sitedata_vmpath, wwwroot, site_name_full, site_name_short, site_admin_user, site_admin_pass, site_admin_email]

end
