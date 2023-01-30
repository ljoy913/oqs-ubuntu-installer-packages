#!/bin/bash -e

#
#
#  Builds libzstd from Debian source
#  For Ubuntu 18.04
#
#


# Package name
PACKAGE=libzstd


# Working dir
WORKDIR=/$PACKAGE
rm -rf $WORKDIR; mkdir $WORKDIR; cd $WORKDIR


# Package source
GIT=https://salsa.debian.org/med-team/libzstd
BRANCH=debian/1.4.8+dfsg-3
git clone --single-branch --branch $BRANCH $GIT $PACKAGE
cd $PACKAGE


# Dependencies
# apt -yqq install \
#     d-shlibs help2man liblz4-dev liblzma-dev zlib1g-dev

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
