# MARTe2-dockers

This repository contains a collection of resources for building, testing and sharing Docker images
that provide reference builds of MARTe2 and related open source projects.

# Supported Workflows

To use this repository to build local docker images, the intended workflow is :

- cd <target>
- ./builder.sh <os>

where each of the directories represents a target which is a combination of particular releases of the
MARTe2 core and components repositories, possibly mixed with othe standard reference stacks (EPICS, MDSplus, ...).

The builder.sh script has some hard coded assumptions about the tag name applied to the docker image.
This is generally for use at UKAEA.  To create a docker image with any other tag, either modify the
builder.sh script, or use standard docker commands to create a new tag for the same image.

## Docker Hub Images

A subset of images are shared via the personal Docker hub account of Adam Stephen.

1. https://hub.docker.com/repository/docker/avstephen/marte2-base-centos7 (from baseline)


## LICENSE

The reference collection license is yet to be finalised.  The licenses for the third party repositories
which are collected, compiled and shared via this toolkit are defined by their respective owners.


