# To do
* db dump loading scripts
* unit test setup
* xdebug install
* moosh
* php7 version
* custom logging location
* yaml validification
* cron setup
* mysql DB install code
* size change script
* custom moodle scripts? place in admin/cli/custom + exclude.
* mail redirects
* custom config settings.
* review vagrant config.
* vagrant halt bridged problem
* set timezone 

CREATE DATABASE eoz_totara DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON eoz_totara.* TO eoz_totara@localhost IDENTIFIED BY 'yourpassword';


VBoxManage clonehd in.vmdk out.vdi --format VDI
VBoxManage modifyhd box.vdi --resize 15360
use gparted


sudo apt-get install php5-xdebug
<pre>
xdebug.remote_enable=1
xdebug.remote_host=127.0.0.1
xdebug.remote_connect_back=1    # Not safe for production servers
xdebug.remote_port=9000
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_autostart=true
</pre>



phpunit
* install composer
add:
<pre>
$CFG->phpunit_prefix = 'phpu_';
$CFG->phpunit_dataroot = '/var/www/phpunitdataroot';
</pre>
to config
* create /var/www/phpunitdataroot
* chmod it
make vendor dir
chmod it
cd siteroot
composer install
sudo locale-gen en_AU.UTF-8
sudo -u www-data php admin/tool/phpunit/cli/init.php


Moodle 28 error: ==> default: Unrecognised options:
==> default:   --adminemail=notanemail@notmail.com
