#!/bin/bash -e

#
#
#  Builds libarchive 3.15.4-1 from Debian source
#  For Ubuntu 18.04
#
#


# Package name
PACKAGE=libarchive


# Working dir
WORKDIR=/$PACKAGE
rm -rf $WORKDIR; mkdir $WORKDIR; cd $WORKDIR


# Package source
GIT=https://salsa.debian.org/debian/libarchive.git
BRANCH=debian/3.6.0-1
git clone --single-branch --branch $BRANCH $GIT $PACKAGE
cd $PACKAGE


# Dependencies
# apt -yqq install \
#     pkg-config libbz2-dev liblz4-dev liblzma-dev libxml2-dev libzstd-dev zlib1g-dev libacl1-dev libext2fs-dev sharutils nettle-dev locales
   
# dpkg-checkbuilddeps

apt-get -yq build-dep .


# Build
#   nocheck        skip running tests (the tests would require additional backports because of a dependency on 'haskell-shake' (>=0.16) )
#   -us -uc        dont sign anything
#   -b             binary packages only
export DEB_BUILD_OPTIONS="nocheck"; dpkg-buildpackage -us -uc -b


# Add the .deb files to the local repository
/scripts/local-repo.sh $PWD/..
wait
