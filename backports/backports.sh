#!/bin/bash

apt -y install debian-keyring debian-archive-keyring
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138 0E98404D386FA1D9 DCC9EFBF77E11517


LIST=/etc/apt/sources.list.d/backports.list

echo "# Bionic =====================================================================

#deb http://azure.archive.ubuntu.com/ubuntu/ bionic main restricted
deb-src http://azure.archive.ubuntu.com/ubuntu/ bionic main restricted

#deb http://azure.archive.ubuntu.com/ubuntu/ bionic-updates main restricted
deb-src http://azure.archive.ubuntu.com/ubuntu/ bionic-updates main restricted

#deb http://azure.archive.ubuntu.com/ubuntu/ bionic-backports main restricted
deb-src http://azure.archive.ubuntu.com/ubuntu/ bionic-backports main restricted

#deb http://archive.ubuntu.com/ubuntu/ bionic universe
deb-src http://archive.ubuntu.com/ubuntu/ bionic universe

#deb http://archive.ubuntu.com/ubuntu/ bionic-updates universe
deb-src http://archive.ubuntu.com/ubuntu/ bionic-updates universe

#deb http://archive.ubuntu.com/ubuntu/ bionic-backports universe
deb-src http://archive.ubuntu.com/ubuntu/ bionic-backports universe

# Focal  =====================================================================

#deb http://azure.archive.ubuntu.com/ubuntu/ focal main restricted
deb-src http://azure.archive.ubuntu.com/ubuntu/ focal main restricted

#deb http://azure.archive.ubuntu.com/ubuntu/ focal-updates main restricted
deb-src http://azure.archive.ubuntu.com/ubuntu/ focal-updates main restricted

#deb http://azure.archive.ubuntu.com/ubuntu/ focal-backports main restricted
deb-src http://azure.archive.ubuntu.com/ubuntu/ focal-backports main restricted

#deb http://archive.ubuntu.com/ubuntu/ focal universe
deb-src http://archive.ubuntu.com/ubuntu/ focal universe

#deb http://archive.ubuntu.com/ubuntu/ focal-updates universe
deb-src http://archive.ubuntu.com/ubuntu/ focal-updates universe

#deb http://archive.ubuntu.com/ubuntu/ focal-backports universe
deb-src http://archive.ubuntu.com/ubuntu/ focal-backports universe

# Jammy  =====================================================================

#deb http://azure.archive.ubuntu.com/ubuntu/ jammy main restricted
deb-src http://azure.archive.ubuntu.com/ubuntu/ jammy main restricted

#deb http://azure.archive.ubuntu.com/ubuntu/ jammy-updates main restricted
deb-src http://azure.archive.ubuntu.com/ubuntu/ jammy-updates main restricted

#deb http://azure.archive.ubuntu.com/ubuntu/ jammy-backports main restricted
deb-src http://azure.archive.ubuntu.com/ubuntu/ jammy-backports main restricted

#deb http://archive.ubuntu.com/ubuntu/ jammy universe
deb-src http://archive.ubuntu.com/ubuntu/ jammy universe

#deb http://archive.ubuntu.com/ubuntu/ jammy-updates universe
deb-src http://archive.ubuntu.com/ubuntu/ jammy-updates universe

#deb http://archive.ubuntu.com/ubuntu/ jammy-backports universe
deb-src http://archive.ubuntu.com/ubuntu/ jammy-backports universe

# Buster =====================================================================

deb-src http://httpredir.debian.org/debian buster main non-free contrib
deb-src http://httpredir.debian.org/debian buster-backports main non-free contrib" > $LIST

apt update


# libfido2-dev (1.5.0-2~bpo10+1)
#     |-  
#
#

