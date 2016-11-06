#!/usr/bin/env bash

wwwroot_hostlocation=$1
wwwroot_git_url=$2
wwwroot_git_branch=$3

mkdir -p $wwwroot_hostlocation
if [ ! -e "$wwwroot_hostlocation/.git" ]
  then
    git clone -b $wwwroot_git_branch $wwwroot_git_url $wwwroot_hostlocation
  else
    echo '.git file already exists'
fi
