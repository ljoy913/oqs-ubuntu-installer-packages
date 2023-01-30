#!/bin/bash -e

#
#
#  Builds dh-runit 2.8.15 from Debian source
#  For Ubuntu 18.04
#
#


# Package name
PACKAGE=dh-runit


# Working dir
WORKDIR=/$PACKAGE
rm -rf $WORKDIR; mkdir $WORKDIR; cd $WORKDIR


# Package source
GIT=https://salsa.debian.org/debian/dh-runit
BRANCH=release-2.8.15
git clone --single-branch --branch $BRANCH $GIT $PACKAGE
cd $PACKAGE

# Dependencies
# apt-get -yqq install \
#     apt-utils perl-doc libfile-copy-recursive-perl libtext-hogan-perl libfile-slurp-perl libghc-shake-dev

apt-get -yq build-dep .

# Build
#   nocheck        skip running tests (the tests would require additional backports because of a dependency on 'haskell-shake' (>=0.16) )
#   -us -uc        dont sign anything
#   -b             binary packages only
export DEB_BUILD_OPTIONS="nocheck"; dpkg-buildpackage -us -uc -b 


# Add the .deb files to the local repository
/scripts/local-repo.sh $PWD/..
wait


# Install the new package from the local repo - this should pickup the latest version that we just built
apt install dh-runit -y
