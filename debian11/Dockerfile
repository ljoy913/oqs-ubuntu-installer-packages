#
# Builds Debian 11 openssh installer packages with liboqs support
#
#   This takes the OQS openssh project and merges it with the formal Debian
#   openssh installer packages.
#
#   - can be installed on Debian 11 using standard apt package installer
#   - formally installed on the OS as the 'openssh' server/client replacing
#     the existing versions.
#
#   All the scripting required to merge and build these packages is in this Dockerfile
#   The resulting image will contain the openssh installer packages in the /debs folder
#   With any required runtime packages (dh-runit, libfido2-dev)
# 




FROM debian:11 AS build



# LABEL about the custom image
LABEL \
    maintainer="ljoy@microsoft.com" \
    version="0.1" \
    description="Build installer package for OQS enabled version of openssh-portable."


# Package name
ARG PACKAGE=openssh


# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive


# Whether or not to retain the patches applied by the distribution (e.g. Debian 18)
ARG RETAIN_PATCHES=1


# Set the timezone or we get prompted when tzdata installs
ENV TZ="America/Los_Angeles"


# Changelog info for the new oqs package
ARG VERSION=1:8.9p1-3~bpo11+oqs1 \
    REVISION=1 \
    PATCH=\
    USER_NAME="user <user@email.com>" \
    USER_EMAIL="user@email.com" \
    CHANGE_DESCRIPTION="Add liboqs support"



# Update repositories and install required utils
RUN apt-get update && apt-get upgrade -y; \
    apt-get install -yq \
    lsb-release \
    tzdata \
    software-properties-common \
    git \
    quilt \
    dpkg-dev \
    # additional packages that are not required
    # nano \
    # init-system-helpers=1.56+nmu1~debian10.1 \
    # build-essential \
    # devscripts \
    wget; \
    apt-get clean all




#
#
# Sources
#
#

ENV LIBOQS_SOURCE=/liboqs \
    OQS_OPENSSH_SOURCE=/openssh-oqs \
    DEBIAN_OPENSSH_SOURCE=/openssh-debian


RUN git clone --single-branch --branch debian/1%8.9p1-3 https://salsa.debian.org/ssh-team/openssh.git $DEBIAN_OPENSSH_SOURCE; \
    git clone --single-branch --branch OQS-v8 https://github.com/open-quantum-safe/openssh.git $OQS_OPENSSH_SOURCE; \
    git clone --single-branch --branch main https://github.com/open-quantum-safe/liboqs.git $LIBOQS_SOURCE;
    # backport sources (for required dependencies with no backport packages available)
    # git clone --single-branch --branch release-2.8.15 https://salsa.debian.org/debian/dh-runit.git /dh-runit/dh-runit;


# Download the openssh source archive so we can do a source build
RUN wget https://launchpad.net/debian/+archive/primary/+sourcefiles/openssh/1:8.9p1-2/openssh_8.9p1.orig.tar.gz




#https://docs.docker.com/engine/reference/builder/#adding-a-git-repository-add-git-ref-dir
#ADD --keep-git-dir=true https://github.com/moby/buildkit.git#v0.10.1 /buildki




#
#
# Dependencies
#
# Build dependencies not available on stock Debian 18
#   libfido2-dev (>= 1.5.0)  available through ppa:yubico/stable (the debian openssh maintainers point to this site)
#   dh-runit ()  we'll build it here as 


# Install required backports that won't get auto-installed by build-dep
# RUN apt-get install -y -t *backports debhelper dwz


# Create a local package repository
ARG REPO_DIRECTORY=/debs
ENV REPO_SOURCE=/etc/apt/sources.list.d/local.list
RUN mkdir -p $REPO_DIRECTORY ;\
    echo "deb [trusted=yes] file:$REPO_DIRECTORY ./" >> $REPO_SOURCE ;\
    cd $REPO_DIRECTORY; dpkg-scanpackages -m . | gzip -9c > Packages.gz 


# # Build dh-runit backport and add to local repository (required for openssh build-dep)
# RUN cd /dh-runit/dh-runit ;\
#     apt-get -yq build-dep . ;\
#     export DEB_BUILD_OPTIONS="nocheck" ;dpkg-buildpackage -us -uc -b ;\
#     cp ../*.deb $REPO_DIRECTORY/. ;\
#     cd $REPO_DIRECTORY; dpkg-scanpackages -m . | gzip -9c > Packages.gz ;\
#     apt-get update -o Dir::Etc::sourcelist="$REPO_SOURCE" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0" 


# # Download backported deb files
# RUN echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" > /etc/apt/sources.list.d/backports.list; \
#     apt update; \
#     apt-get download -t *backports libfido2-dev=1.5.0-2~bpo10+1 debhelper=13.3.3~bpo10+1 dwz=0.13-5~bpo10+1; \
#     mv *.deb $REPO_DIRECTORY/. ;\
#     cd $REPO_DIRECTORY; dpkg-scanpackages -m . | gzip -9c > Packages.gz ;\
#     apt-get update -o Dir::Etc::sourcelist="$REPO_SOURCE" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0" 


# Liboqs dependencies
RUN apt-get install -yq \
    astyle cmake gcc ninja-build libssl-dev python3-pytest python3-pytest-xdist unzip xsltproc doxygen graphviz python3-yaml valgrind 


# Openssh dependencies
RUN cd $DEBIAN_OPENSSH_SOURCE; \
    apt-get -yq build-dep .



#
#
# Dist Patches  =========================================================================
#
#

# Debian openssh maintainers ship their code pre-patched. Meaning the source already contains the patches applied and nothing in the 'patches' folder
# This will reconstruct those patches and remove from the source
WORKDIR $DEBIAN_OPENSSH_SOURCE


# Removes the applied patches. Creates a new patch with all the OQS changes to openssh-portable. 
RUN export QUILT_PATCHES=debian/patches; \
    [ ! -d .pc ] ; for patch in $(quilt series | tac); do patch -p1 -R --no-backup-if-mismatch <"${patch}"; done; \
    quilt push -a; \
    tar -cvJf ../openssh_8.9p1.orig.tar.xz . ;\
    quilt pop -a ;\
    quilt new oqs.patch; \
    find $OQS_OPENSSH_SOURCE -type f -name \* -print | xargs realpath --relative-base=$OQS_OPENSSH_SOURCE | xargs quilt add; \
    cp -rv $OQS_OPENSSH_SOURCE/* $DEBIAN_OPENSSH_SOURCE; \
    quilt refresh -p ab --strip-trailing-whitespace; \
    quilt pop


# Reapply the patches + oqs.patch on top of those with fuzz=3 (fuzz attempts to patch when the diff files are not exact)
RUN if [ $RETAIN_PATCHES -eq 1 ]; then \
    # Reapply the debian patches, then apply the new oqs.patch over that
    sed -i '/oqs.patch/d' debian/patches/series ;\
    echo oqs.patch >> debian/patches/series ;\ 
    quilt push -a --fuzz=3 ;\
    quilt refresh -p ab --strip-trailing-whitespace ;\
    else \
    # Applies only the oqs.patch. The debian patches are not applied.
    echo oqs.patch > debian/patches/series ;\
    quilt push;\
    sed -i '\|^usr/share/man/man5/authorized_keys.5$|d' debian/openssh-server.install ;\
    fi 


# Create a new patch to update the config
RUN quilt new oqs.config.patch && \
    quilt add debian/rules debian/systemd/ssh.service sshd_config && \
    sed -i 's/^Description=OpenBSD Secure Shell server$/Description=OpenBSD Secure Shell server (with liboqs)/g' debian/systemd/ssh.service && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' sshd_config && \
    quilt refresh -p ab --strip-trailing-whitespace


# Moved this outside the patch above since we can't debuid with debian/rules modifications
RUN sed -i '/^# The Hurd needs libcrypt for res_query et al.$/i # OQS specific flags\n\
    confflags += --with-liboqs-dir=/oqs\n\
    ' debian/rules

# RUN sed -i '/^# The Hurd needs libcrypt for res_query et al.$/i # OQS specific flags\n\
#     confflags += --with-ssl-dir=/usr\n\
#     confflags += --with-liboqs-dir=/oqs\n\
#     confflags += --with-libs=-lm\n\
#     ' debian/rules



#
#
# Build liboqs 
#
#
RUN cd $LIBOQS_SOURCE; mkdir build; cd build ;\
    cmake .. -GNinja -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX=/oqs ;\
    ninja ;\
    ninja install




#
#
# Build openssh packages
#
#

# Update the changelog - This is how the package gets it version
RUN CHANGELOGENTRY="$PACKAGE ($VERSION.$REVISION$PATCH) UNRELEASED; urgency=medium\n\n  * $CHANGE_DESCRIPTION\n\n -- $USER <$USER_EMAIL>  $(echo `date '+%a, %d %b %Y %T %z'`)\n\n" ;\
    echo "$CHANGELOGENTRY$(cat debian/changelog)" > debian/changelog

#Build the binary deb packages and skip the tests
#dpkg-checkbuilddeps
RUN export DEB_BUILD_OPTIONS="nocheck" ;dpkg-buildpackage -us -uc -b

# Add the .deb files to the local repository
# This will allow you to use the output volume folder as a repository
RUN cp ../*.deb $REPO_DIRECTORY/. ;\
    cd $REPO_DIRECTORY; dpkg-scanpackages -m . | gzip -9c > Packages.gz ;\
    apt-get update -o Dir::Etc::sourcelist="$REPO_SOURCE" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"





# Spin up a new OS with just the packages. Now the image wont have all the build bloat.
FROM debian:10


# Enable this to build a full image instead of the minimized default
# RUN yes | unminimize


# Copy the packages from the build image to this image
ARG REPO_DIRECTORY=/debs
COPY --from=build $REPO_DIRECTORY/* $REPO_DIRECTORY/


# Copy the packages to the volume
CMD [ "cp", "-r", "/debs/.", "/packages" ]
