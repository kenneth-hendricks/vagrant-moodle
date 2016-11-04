#!/usr/bin/env bash

db_type=$1
db_name=$2
db_user=$3
db_pass=$4
wwwroot_hostlocation=$5
wwwroot_vmpath=$6
sitedata_hostlocation=$7
sitedata_vmlocation=$8

echo "### $db_type $db_name $db_user $db_pass $sitedata_hostlocation $sitedata_vmlocation"

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache2 and php 5
sudo apt-get install -y apache2
sudo apt-get install -y php5

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
    DocumentRoot "${wwwroot_vmpath}"
    <Directory "${wwwroot_vmpath}">
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

# install git
sudo apt-get -y install git

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
