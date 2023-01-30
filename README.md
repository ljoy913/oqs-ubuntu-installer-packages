# OQS 8.9 SSH Ubuntu and Debian Installer Packages

This project takes the Open Quantum Safe [OQS-OpenSSH](https://github.com/open-quantum-safe/openssh) and builds installable client/server packages for Ubuntu and Debian.

The OQS-OpenSSH project, provided by OQS, allows you build SSH binaries on your system, but you cannot install them as a replacement for you existing SSH client/server.

This project packages the OQS-OpenSSH binaries into installer packages that can be installed on Debian/Ubuntu systems, replacing the exiting SSH applications.

These installer packages are adapted from the actual Debian 8.9 SSH packages maintaining their configuration and patches to preserve compatibility.

<br>

## Dependencies
- Node/Npm
- Git
- Docker

<br>

## Build Packages
This process creates a Docker image of the desired Debian/Ubuntu distribution with all the required dependencies. After the image is created the build process will generate the installer packages and export them to the local /packages folder.  

<br>

1. Build the desired Docker image for your desired distribution:  

   ```
   npm run docker:ubuntu18.04:image
   ```

2. Build and export the packages:  

   ```
   npm run docker:ubuntu18.04:build
   ```

The resulting `deb` packages will appear in a `/packages` sub-folder for the specified system.
Along with the openssh packages, there may be additional deb files that are back-ported dependencies.

<br>

## Installing Packages
Installing the package will replace the existing SSH package(s) as an upgrade.
1. Copy the entire `/packages` folder to the installation machine.
2. `cd` to the folder.
3. Run `sudo apt install ./openssh-client_8.9p1-3~bpo18.04+oqs1.1_amd64.deb`

<br>

## Packages

Distribution | Distro Version | OQS-SSH Package | Required Backports  
:----- | :----: | :----: | -----:  
Debian 10   | 1:7.9p1-10+deb10u2 | openssh-client_8.9p1-3~bpo10+oqs1.1_amd64 | runit-helper, dwz, dh-runit, libfido2, debhelper
Debian 11  | 1:8.4p1-5+deb11u1  | openssh-client_8.9p1-3~bpo11+oqs1.1_amd64 | N/A
Ubuntu 18.04  | 1:7.6p1-4ubuntu0.7  | 8.9p1-3~bpo18.04+oqs1.1_amd64 | dh-runit, libcbor-dev, libcbor, libfido2, libfido2-dev, runit-helper
Ubuntu 20.04  | 1:8.2p1-4ubuntu0.5 | 8.9p1-3~bpo20.04+oqs1.1_amd64 | libfido2, libfido2-dev
Ubuntu 22.04  | 1:8.9p1-3ubuntu0.1  | 8.9p1-3~bpo22.04+oqs1.1_amd64 | N/A

<br>

# Status  
[\(verbatim from OQS-OpenSSH project\)](https://github.com/open-quantum-safe/openssh#status)

This fork is currently based on OpenSSH version 8.9 (Git tag V_8_9_P1); release notes can be found here. **IT IS AT AN EXPERIMENTAL STAGE**, and has not received the same level of auditing and analysis that OpenSSH has received. See the Limitations and Security section below for more information.

**WE DO NOT RECOMMEND RELYING ON THIS FORK TO PROTECT SENSITIVE DATA.**