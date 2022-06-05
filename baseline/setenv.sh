#!/usr/bin/env bash
#
# Set environment variables for the project.  Referenced from other install and run scripts.
#
# 2022-01-22 passes shellcheck linting OK.
# 2022-01-22 : bashtip : surround shell expansion strings in double quotes : shellcheck
# 2022-01-22 : bashtip : use || exit after a cd attempt in case the directory is not found : shellcheck
# 2022-06-04 : Add a function that generates a Docker env_file from the computed values
# 
# TODO: use the following to avoid any absolute path reference assumptions : install wherever cloned to.
#set -x


export SCRIPT="${BASH_SOURCE[${#BASH_SOURCE[@]} - 1]}"
export SCRIPT_REALPATH=$(realpath "$SCRIPT")
export SCRIPT_NAME=$(basename "$SCRIPT_REALPATH")
export SCRIPT_DIR=$(dirname "$SCRIPT_REALPATH")

if [ $# -eq 0 ]
then
export PATH=$PATH:${SCRIPT_DIR}
export INSTALLATION_DIR=$(realpath "$SCRIPT_DIR")
else
        INSTALLATION_DIR=$1
        shift
fi

export MARTe2_PROJECT_ROOT=${INSTALLATION_DIR}/MARTe2-sigtools
export MARTe2_Sigtools_Dependencies_Installed_File=${MARTe2_PROJECT_ROOT}/marte2-sigtools.deps.installed
export MARTe2_Sigtools_Repos_Installed_File=${MARTe2_PROJECT_ROOT}/marte2-sigtools.repos.installed
export MARTe2_DIR=${MARTe2_PROJECT_ROOT}/MARTe2-dev
export MARTe2_Components_DIR=${MARTe2_PROJECT_ROOT}/MARTe2-components
export MARTe2_Demos_Sigtools_DIR=${MARTe2_PROJECT_ROOT}/MARTe2-demos-sigtools/
# Avoid building the OPCUADataSource by suppressing the next two lines
# https://github.com/AdamVStephen/MARTe2-sigtools/blob/issues/issues/%230001_MARTe2-components_build/OPCUAClient.md
#export OPEN62541_LIB=${MARTe2_PROJECT_ROOT}/Projects/open62541/build/bin
#export OPEN62541_INCLUDE=${MARTe2_PROJECT_ROOT}/Projects/open62541/build
export EPICS_BASE=${INSTALLATION_DIR}/epics-base-7.0.6
export EPICSPVA=${INSTALLATION_DIR}/epics-base-7.0.6
export EPICS_HOST_ARCH=linux-x86_64
export SDN_CORE_INCLUDE_DIR=${INSTALLATION_DIR}/SDN_1.0.12_nonCCS/src/main/c++/include/
export SDN_CORE_LIBRARY_DIR=${INSTALLATION_DIR}/SDN_1.0.12_nonCCS/target/lib/

# TODO: Make this idempotent to avoid excessive path growth
export PATH=$PATH:${INSTALLATION_DIR}/epics-base-7.0.6/bin/linux-x86_64
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MARTe2_DIR/Build/x86-linux/Core/:$EPICS_BASE/lib/$EPICS_HOST_ARCH:$SDN_CORE_LIBRARY_DIR
#export MDSPLUS_DIR=/usr/local/mdsplus

export MARTe2_CONFIG_PATH=${MARTe2_Demos_Sigtools_DIR}/Configurations

#source $SCRIPT_DIR/ex1-completion.bash

# EPICS Environment : tune per machine
# Broadcast address of the specifc network
export EPICS_CA_ADDR_LIST=10.208.19.255
export EPICS_CA_AUTO_ADDR_LIST=NO

make_docker_env(){
        echo "# Creating Docker ENV file env_docker"
        > env_docker
for var in INSTALLATION_DIR MARTe2_DIR MARTe2_Components_DIR
do
        echo $var=${!var} | tee -a env_docker
done
}


make_docker_env
