#!/usr/bin/env bash 
#
# Install dependencies not yet fully wrapped in a package manager.
#
# TODO: apply the lookup table method to list options for alternative combinations.
# Guard against unset variable expansion
set -u
set -x
SCRIPT="$0"
SCRIPT_DIR=$(dirname $(realpath "$SCRIPT"))
source "${SCRIPT_DIR}/utils.sh"

if [ $# -ne 1 ]
then
	{ echo "Uage: $SCRIPT <target-dir>"; exit 54;}
fi

export INSTALLATION_DIR="$1"

if [ ! -d "$INSTALLATION_DIR" ]
then
	  { echo "$INSTALLATION_DIR doesn't exist"; exit 55;}
fi

install_source () {

cd "$INSTALLATION_DIR" || { echo "Unable to cd to $INSTALLATION_DIR"; exit 56; }
  
# MARTe2 and MARTe2-components
#
# TODO: parameterise options for which distribution

git clone https://github.com/aneto0/MARTe2.git

git clone https://github.com/aneto0/MARTe2-components.git

# TODO: fix up the expectations about locations (what *is* this all about anyway?)
ln -sf "${INSTALLATION_DIR}/MARTe2" "${INSTALLATION_DIR}/MARTe2-dev"

 # EPICS R7.0.2
 # Padua 2019 compatibility
 git clone -b R7.0.2 --recursive https://github.com/epics-base/epics-base.git epics-base-7.0.2
  
 # Open Source OPCUA
 # Padua 2019 compatibility
 git clone -b 0.3 https://github.com/open62541/open62541.git open62541-0.3

 # EPICS R7.0.6
 # git clone -b R7.0.6 --recursive https://github.com/epics-base/epics-base.git epics-base-7.0.6
  
  # Open Source OPCUA
 # git clone -b 1.3 https://github.com/open62541/open62541.git open62541-1.3
  
  # Download SDN:
  wget https://vcis-gitlab.f4e.europa.eu/aneto/MARTe2-demos-padova/raw/develop/Other/SDN_1.0.12_nonCCS.tar.gz
  
  tar zxvf SDN_1.0.12_nonCCS.tar.gz

}

install_source "$INSTALLATION_DIR"

