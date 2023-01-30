#!/bin/bash

#
#
# Sets up a local package repository
# Usefull when you want to use local deb files as dependencies in apt package installs
#
#

REPO_SOURCE=/etc/apt/sources.list.d/local.list
REPO_DIRECTORY=$DEBS
CURRENT_DIR=$PWD

if [[ ! -f $REPO_SOURCE ]] 
then 
  echo "deb [trusted=yes] file:$REPO_DIRECTORY ./" >> $REPO_SOURCE
  mkdir -p $REPO_DIRECTORY
fi


if [ "$1" ]
  then
    cp $1/*.deb $REPO_DIRECTORY/.
fi

cd $REPO_DIRECTORY

dpkg-scanpackages -m . | gzip -9c > Packages.gz

apt-get update -o Dir::Etc::sourcelist="$REPO_SOURCE" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"

cd $CURRENT_DIR
