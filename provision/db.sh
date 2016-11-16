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

#conditional DB install - either pgsql or mysql
if [ "$db_type" == "pgsql" ]
then
  # install postrgres and apache libs
  sudo apt-get install -y postgresql postgresql-contrib
  sudo apt-get install -y php5-pgsql
  sudo -u postgres psql -c "CREATE USER $db_user WITH PASSWORD '$db_pass';"
  sudo -u postgres psql -c "CREATE DATABASE $db_name WITH OWNER $db_user;"
elif [ "$db_type" == "mysql" ]
then
    sudo apt-get install -y mysql-server
    sudo apt-get install php5-mysql
fi

# restart apache
service apache2 restart
