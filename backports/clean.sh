#!/bin/bash

rm /etc/apt/sources.list.d/local.list

rm $DEBS/*

apt-get update

apt remove dh-runit -y

rm -rf /dh-runit
