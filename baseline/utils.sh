#!/usr/bin/env bash
#
# Common shell utilities for the install scripts

get_distro() {
	distro_id=$(grep "^ID=" /etc/os-release)
	# V1: fragile : Extract name from inside quotes
	#distro_id=${distro_id#*\"}
	#distro_id=${distro_id%*\"}
	# V2 more explicit : strip ID= prefix and any quotes
	distro_id=${distro_id#"ID="}
	distro_id=$(echo "$distro_id" | tr -d '"')
	# V1: Likewise for version
	distro_version=$(grep "^VERSION_ID" /etc/os-release)
	#distro_version=${distro_version#*\"}
	#distro_version=${distro_version%*\"}
	# V2 more explicit
	distro_version=${distro_version#"VERSION_ID="}
	distro_version=$(echo "$distro_version" | tr -d '"')
	echo "${distro_id}${distro_version}"
}
	
