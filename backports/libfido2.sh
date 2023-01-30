#!/bin/bash -e

#
#
#  Builds libfido2-dev from Debian source
#  For Ubuntu 18.04
#
#


# Package name
PACKAGE=libfido2


# Working dir
WORKDIR=/$PACKAGE
rm -rf $WORKDIR; mkdir $WORKDIR; cd $WORKDIR


# Package source
GIT=https://salsa.debian.org/auth-team/libfido2.git
BRANCH=debian/1.5.0-2
git clone --single-branch --branch $BRANCH $GIT $PACKAGE
cd $PACKAGE


# Dependencies
# apt -yqq install \
#     pkg-config cmake mandoc libcbor-dev libssl-dev libudev-dev

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
