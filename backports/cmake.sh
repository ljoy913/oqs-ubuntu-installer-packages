#!/bin/bash -e

#
#
#  Builds cmake from Debian source
#  For Ubuntu 18.04
#
#


# Package name
PACKAGE=cmake


# Working dir
WORKDIR=/$PACKAGE
rm -rf $WORKDIR; mkdir $WORKDIR; cd $WORKDIR


# Package source
GIT=https://salsa.debian.org/cmake-team/cmake.git
BRANCH=debian/3.15.4-1
git clone --single-branch --branch $BRANCH $GIT $PACKAGE
cd $PACKAGE


# Dependencies
# apt -yqq install \
#     libarchive-dev libbz2-dev libcurl4-openssl-dev libexpat1-dev libjsoncpp-dev liblzma-dev \
#     libncurses5-dev librhash-dev libuv1-dev python3-sphinx qtbase5-dev zlib1g-dev
   
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
