#!/usr/bin/env bash

wwwroot_hostlocation=$1
wwwroot_git_url=$2
wwwroot_git_branch=$3

git clone -b $wwwroot_git_branch $wwwroot_git_url $wwwroot_hostlocation
