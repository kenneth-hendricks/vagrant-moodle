#!/usr/bin/env bash

siteroot_hostlocation=$1
siteroot_git_url=$2
siteroot_git_branch=$3

mkdir -p $siteroot_hostlocation
if [ ! -e "$siteroot_hostlocation/.git" ]
  then
    git clone -b $siteroot_git_branch $siteroot_git_url $siteroot_hostlocations
  else
    echo '.git file already exists, not cloning'
fi

# ignore wwroot from vagrant repo
echo $siteroot_hostlocation >> .git/info/exclude
