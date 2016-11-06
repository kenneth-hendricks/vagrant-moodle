#!/usr/bin/env bash

db_type=$1
db_name=$2
db_user=$3
db_pass=$4
siteroot_hostpath=$5
siteroot_vmpath=$6
sitedata_hostpath=$7
sitedata_vmpath=$8
wwwroot=$9;
site_name_full=$10
site_name_short=$11
site_admin_user=$12
site_admin_pass=$13

echo "### $db_type $db_name $db_user $db_pass $sitedata_hostpath $sitedata_vmpath"

sudo mkdir -p $sitedata_vmpath
sudo chmod 0777 $sitedata_vmpath

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache2 and php 5
sudo apt-get install -y apache2
sudo apt-get install -y php5
sudo apt-get install -y php5-curl php5-gd php5-xmlrpc php5-intl

#conditional DB install - either pgsql or mysql
if [ "$db_type" == "pgsql" ]
then
  # install postrgres and apache libs
  sudo apt-get install -y postgresql postgresql-contrib
  sudo apt-get install -y libapache2-mod-php5 php5-pgsql
  sudo -u postgres psql -c "CREATE USER $db_user WITH PASSWORD '$db_pass';"
  sudo -u postgres psql -c "CREATE DATABASE $db_name WITH OWNER $db_user;"
fi

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "${siteroot_vmpath}"
    <Directory "${siteroot_vmpath}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
service apache2 restart

sudo php $siteroot_vmpath/admin/cli/install.php --non-interactive --wwwroot=$wwwroot --dataroot=$sitedata_vmpath --dbtype=$db_type --dbname=$db_name --dbuser=$db_user --dbpass=$db_pass --fullname=$site_name_full --shortname=$site_name_short --adminuser=$site_admin_user --adminpass=$site_admin_pass --agree-license
chmod a+r $siteroot_vmpath/config.php


# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
