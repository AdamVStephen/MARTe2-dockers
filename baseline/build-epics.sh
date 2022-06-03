#!/usr/bin/env bash
#
# Compile EPICS
#
# Guard against unset variable expansion
set -u
SCRIPT="$0"
SCRIPT_DIR=$(dirname $(realpath "$SCRIPT"))
source "${SCRIPT_DIR}/utils.sh"

if [ $# -lt 1 ]
then
	{ echo "Usage: $SCRIPT <target-dir>"; exit 54; }
fi

INSTALLATION_DIR="$1"
if [ ! -d "$INSTALLATION_DIR" ]
then
	{ echo "$INSTALLATION_DIR doesn't exist"; exit 55; }
fi

if [ $# -eq 2 ]
then
        EPICS_VERSION=7.0.2
else
        EPICS_VERSION=$2
fi

compile_epics() {
  
cd "${INSTALLATION_DIR}" || { echo "Unable to cd to $INSTALLATION_DIR"; exit 56; }

  mkdir -p ${INSTALLATION_DIR}/open62541/build && cd $_ && cmake3 .. && make
  
  cd ${INSTALLATION_DIR}/epics-base-${EPICS_VERSION} && echo "OP_SYS_CXXFLAGS += -std=c++11" >> configure/os/CONFIG_SITE.linux-x86_64.Common
  
  cd ${INSTALLATION_DIR}/epics-base-${EPICS_VERSION} && make
  
}

compile_epics
