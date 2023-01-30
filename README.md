# OQS 8.9 Ubuntu and Debian Installer Packages

This project takes the OQS modified openssh-portable and builds installable packages for Ubuntu and Debian.

OQS's version of ssh is not really usable on it's own.  You can instantiate a local instance of a server and a client, but you cannot install it as the 'ssh' on your system.
The installer packages have their own scripts, patches, and logic required to do a formal installation replacing the existing ssh packages.

We're not writing the installer code from scratch. Instead, we're taking the existing intaller code from an existing Debing package and replacing the openssh-portable source with the OQS version.
This is complicated by the Debian patches that are applied.
Debian (and Ubuntu) apply a series of patches to the base openssh-portable source to modify it before building the package.  These patches do a variety of things like: restoring old functionality for backwards compatibility, updating defaults, backporting security fixes, customizing output.