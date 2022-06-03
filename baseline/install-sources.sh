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

if [ $# -eq 2 ]
then
        EPICS_VERSION=$2
else
        EPICS_VERSION=7.0.2
fi


# TODO: Map the versions of MARTe for compatibility.

case "$EPICS_VERSION" in

        7.0.2)
                EPICS_BRANCH=R7.0.2
                OPCUA_BRANCH=0.3
                ;;
        
        7.0.6)
                EPICS_BRANCH=R7.0.6
                OPCUA_BRANCH=1.3
                ;;

        *)
                echo "EPICS_VERSION $EPICS_VERSION not yet supported"
                exit 54
;;
esac

install_source () {

cd "$INSTALLATION_DIR" || { echo "Unable to cd to $INSTALLATION_DIR"; exit 56; }
  
# MARTe2 and MARTe2-components
#
# TODO: parameterise options for which distribution

git clone https://github.com/aneto0/MARTe2.git

git clone https://github.com/aneto0/MARTe2-components.git

# TODO: fix up the expectations about locations (what *is* this all about anyway?)
ln -sf "${INSTALLATION_DIR}/MARTe2" "${INSTALLATION_DIR}/MARTe2-dev"

 git clone -b ${EPICS_BRANCH} --recursive https://github.com/epics-base/epics-base.git epics-base-${EPICS_VERSION}
  
 # Open Source OPCUA
 git clone -b ${OPCUA_BRANCH}  https://github.com/open62541/open62541.git open62541

  # Download SDN:
  wget https://vcis-gitlab.f4e.europa.eu/aneto/MARTe2-demos-padova/raw/develop/Other/SDN_1.0.12_nonCCS.tar.gz
  
  tar zxvf SDN_1.0.12_nonCCS.tar.gz

}

install_source "$INSTALLATION_DIR"

