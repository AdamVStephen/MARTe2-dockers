#!/usr/bin/env bash
#
# Pick up common definitions as well as completions.
source ./builder-completion.bash

MARTe2_REF="v1.6.0"

MARTe2_components_REF="v1.5.1"

EPICS_VERSION="7.0.2"

export TAG="m2-${MARTe2_REF}-m2c-${MARTe2_components_REF}-ep-${EPICS_VERSION}"

# NB : No Capitals permitted in the docker name even if there are such in the repo name.
export DOCKER_TAG_PREFIX=git.ccfe.ac.uk:4567/marte2/dockers/marte2-dockers/baseline-

usage() {
        echo "builder.sh distro [--get-image-name]"
        echo "Build or list image name if --get-image-name option is provided"
        echo "Supported distros"
        for d in ${SUPPORTED_DISTROS}
        do
                echo -e "\t$d"
        done
        exit 42
}

build_stage() {

        TARGET_STAGE=$1
        TARGET_OS=$2
        TAG=$3
        invalidate_cache=$4

        if [ x"$invalidate_cache" == "xy" ]
        then
                CACHE_OPT="--build-arg CACHE_DATE=$(date +%s) "
        else
                unset CACHE_OPT
        fi

        this_log="build.${TARGET_OS}.${TARGET_STAGE}.${TAG}.$(date +%s).log"

        # shellcheck disable=SC2086 # code is rrelevant because quotes areound CACHE_OPT would break
        time docker build ${CACHE_OPT} \
                --target "${TARGET_STAGE}" \
                --build-arg "MARTe2_REF=${MARTe2_REF}" \
                --build-arg "MARTe2_components_REF=${MARTe2_components_REF}" \
                --build-arg "EPICS_VERSION=${EPICS_VERSION}" \
                --build-arg "TAG=${TAG}" \
                -t "${DOCKER_TAG_PREFIX}${TARGET_OS}:${TAG}" \
                -f "Dockerfile.${TARGET_OS}.multistage" . 2>&1 | tee "$this_log"

        ln -fs "$this_log" "${TARGET_OS}.last.log"

}

build_all(){
        TARGET_OS=$1
        TAG=$2
        invalidate_cache=$3
        build_stage marte2_base "${TARGET_OS}" "${TAG}" "${invalidate_cache}"
        build_stage marte2_packages "${TARGET_OS}" "${TAG}" "${invalidate_cache}"
        build_stage marte2_source "${TARGET_OS}" "${TAG}" "${invalidate_cache}"
        build_stage marte2_epics_built "${TARGET_OS}" "${TAG}" "${invalidate_cache}"
        build_stage marte2_core_built "${TARGET_OS}" "${TAG}" "${invalidate_cache}"
        build_stage marte2_sdn_built "${TARGET_OS}" "${TAG}" "${invalidate_cache}"
        build_stage marte2_built "${TARGET_OS}" "${TAG}" "${invalidate_cache}"
        build_stage marte2_env "${TARGET_OS}" "${TAG}" "${invalidate_cache}"
}


### TODO: update opt/arg parsing.

if [ $# -eq 0 ]
then
        usage
        exit 0
else
        distro=$1
        shift
        if [[ "$SUPPORTED_DISTROS" =~ (^|[[:space:]])"$distro"($|[[:space:]]) ]]
        then
                if [ $# -eq 0 ]
                then
                        build_all "$distro" "$TAG" y
                else
                        echo "${DOCKER_TAG_PREFIX}${TARGET_OS}:${TAG}" 
                fi 
        else
                usage
                exit 54
        fi
fi
