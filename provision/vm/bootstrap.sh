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
site_name_full=${10}
site_name_short=${11}
site_admin_user=${12}
site_admin_pass=${13}
site_admin_email=${14}
virtualbox_box=${15}

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

if [ "$virtualbox_box" == "ubuntu/trusty64" ]
then
    packages='apache2 php5 php5-curl php5-gd php5-xmlrpc php5-intl libapache2-mod-php5 php5-pgsql php5-mysql'
elif [ "$virtualbox_box" == "ubuntu/xenial64" ]
then
    packages='apache2 php7.0 php7.0-curl php7.0-gd php7.0-xmlrpc php7.0-intl php7.0-xml php7.0-zip php7.0-mcrypt php7.0-mbstring php7.0-soap libapache2-mod-php7.0 php7.0-mysql php7.0-pgsql'
fi

sudo apt-get install -y $packages

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
