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

if [ "$virtualbox_box" == "ubuntu/trusty64" ]
then
    ip="$(ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"
elif [ "$virtualbox_box" == "ubuntu/xenial64" ]
then
    ip="$(ifconfig enp0s8 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"
fi

sudo mkdir -p $sitedata_vmpath

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

sudo php $siteroot_vmpath/admin/cli/install.php --non-interactive --wwwroot=http://$ip --dataroot=$sitedata_vmpath --dbtype=$db_type --dbname=$db_name --dbuser=$db_user --dbpass=$db_pass --fullname=$site_name_full --shortname=$site_name_short --adminuser=$site_admin_user --adminpass=$site_admin_pass --adminemail=$site_admin_email --agree-license
chmod a+r $siteroot_vmpath/config.php

sudo chmod 0777 $sitedata_vmpath

