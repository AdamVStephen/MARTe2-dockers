# Docker Resources for MARTe2

This repository includes resources to build reusable Docker images for MARTe2.

The design separates three types of resource :

1. Dockerfiles : with instructions for docker containers to be built.
1. Shell scripts used by the Docker files, separating packages, source code and build procedures.
1. Driver script - 'builder.sh' which controls and logs the build.

The Dockerfiles use multistage format to try and maximise caching and minimise round trip revisions.

The shell scripts abstract differences in Linux distribution package naming and are intended to be
usable when installing the same software collection on a real machine (or other virtualised solution).



