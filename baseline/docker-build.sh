#!/usr/bin/env bash
#
#
# Latch the build commands to ensure reproducibility.

# TODO: test all combinations (cache/no-cache)
# TODO: refactor to eliminate the duplication

source ./builder-completion.bash

RELEASED_TAGS="v1.6.0-v1.5.1"

usage() {
	echo "builder.sh distro [codename]"
	echo
	echo "Supported distros"
	for d in ${SUPPORTED_DISTROS}
	do
		echo -e "\t$d"
	done
	exit 42
}

###
### GENERIC
###

export TAG=v0.1.0
export DOCKERFILE_CENTOS7=Dockerfile.centos7.multistage

# NB : No Capitals permitted in the docker name even if there are such in the repo name.
export DOCKER_TAG_PREFIX=git.ccfe.ac.uk:4567/marte2/dockers/marte2-dockers/baseline-

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


#build_all centos7 ayr y
#build_all ubuntu1804 ayr n
#build_all ubuntu2004 ayr n
#build_all debian11 ayr n


### TODO: get a grip on parsing args and options in bash !

if [ $# -eq 0 ]
then
	usage
	exit 0
else
distro=$1
shift
if [[ "$SUPPORTED_DISTROS" =~ (^|[[:space:]])"$distro"($|[[:space:]]) ]]
then
	#echo "$distro IS supported : congratulations"
	# With cache invalidation
	#build_all "$distro" "$TAG" y
	# Without cache invalidation
	build_all "$distro" "$TAG" n
else
	usage
	exit 54
fi
fi
