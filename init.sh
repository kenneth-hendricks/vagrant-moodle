#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script will setup the current folder so it is ready for vagrant up.

It will download a git repo into siteroot, checkout the branch specified
and git submodule init.

It will also create a sitedata folder and chmod it with the appropriate permissions.

OPTIONS:
   -h      Show this message
   -r      Repo
   -b      Branch
EOF
}

REPO=
BRANCH=
SITEROOT=siteroot

while getopts "hr:b:" OPTION
do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        r)
            REPO=$OPTARG
            ;;
        b)
            BRANCH=$OPTARG
            ;;
    esac
done

if [[ -z $REPO ]] || [[ -z $BRANCH ]]
then
     usage
     exit 1
fi

mkdir -p $SITEROOT
if [ ! -e "$SITEROOT/.git" ]
  then
    git clone -b $BRANCH $REPO $SITEROOT
    git -C $SITEROOT submodule init
    git -C $SITEROOT submodule update
  else
    echo '.git file already exists, not cloning'
fi
