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

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
