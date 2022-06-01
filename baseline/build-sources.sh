#!/usr/bin/env bash
#
# Compile dependencies not yet fully wrapped in a package manager.
#
# TODO: apply the lookup table method to list options for alternative combinations.
# Guard against unset variable expansion
set -u
SCRIPT="$0"
SCRIPT_DIR=$(dirname $(realpath "$SCRIPT"))
source "${SCRIPT_DIR}/utils.sh"

if [ $# -ne 1 ]
then
	{ echo "Usage: $SCRIPT <target-dir>"; exit 54; }
fi

INSTALLATION_DIR="$1"
if [ ! -d "$INSTALLATION_DIR" ]
then
	{ echo "$INSTALLATION_DIR doesn't exist"; exit 55; }
fi

compile_epics() {
  
cd "$INSTALLATION_DIR" || { echo "Unable to cd to $INSTALLATION_DIR"; exit 56; }

  # Build the open62541 library:
  export OPCUA_BRANCH=1.3
  ln -sf ${INSTALLATION_DIR}/open62541} ${INSTALLATION_DIR}/open62541-${OPCUA_BRANCH}
  
  mkdir -p ${INSTALLATION_DIR}/open62541/build && cd $_ && cmake3 .. && make
  
  
  #Compiling EPICS 7.0.2
  cd ${INSTALLATION_DIR}/epics-base-7.0.2 && echo "OP_SYS_CXXFLAGS += -std=c++11" >> configure/os/CONFIG_SITE.linux-x86_64.Common
  cd ${INSTALLATION_DIR}/epics-base-7.0.2 && make
  
  #Compiling EPICS 7.0.6
  #cd ${INSTALLATION_DIR}/epics-base-7.0.6 && echo "OP_SYS_CXXFLAGS += -std=c++11" >> configure/os/CONFIG_SITE.linux-x86_64.Common
  #cd ${INSTALLATION_DIR}/epics-base-7.0.6 && make
}

compile_marte2() {
  
cd "$INSTALLATION_DIR" || { echo "Unable to cd to $INSTALLATION_DIR"; exit 56; }

cd "${INSTALLATION_DIR}/MARTe2" && make -f Makefile.x86-linux
  
cd "${INSTALLATION_DIR}/SDN_1.0.12_nonCCS" && make

cd "${INSTALLATION_DIR}/MARTe2-components" && make -f Makefile.x86-linux

}

compile_epics
compile_marte2
