#!/usr/bin/env bash
#
# MARTe2 system installation support script : packaged dependencies, function per distro.
#
# TODO: consider cmake / make menuconfig approach to further customisation.
#
# TODO: find a standard way to map generic packages to the distro specific equivalent.
#       - there is a website with this kind of data, and probably a cli interface.
#
# Guard against unset variable expansion
set -u
SCRIPT="$0"
SCRIPT_DIR=$(dirname $(realpath "$SCRIPT"))
source "${SCRIPT_DIR}/utils.sh"

install_packages_centos7() {
	yum -y install epel-release && yum -y update
	# Development package as a group
	yum -y groups install "Development Tools"

	# Inherited from Dockerfile.rtcc2.model : todo, refactor
	#
	# TODO: why do we need lapack ?

#	apt install -y software-properties-common && add-apt-repository --yes ppa:deadsnakes/ppa

yum -y install python3.7 python3.7-dev python3-pip build-essential cmake tar wget libxml2-dev bc libblas3 liblapack3 liblapack-dev libblas-dev gfortran libatlas-base-dev gdb tcl cgdb gdb wireshark vim tmux tcpdump strace shellcheck pstack

apt install -y ncurses-dev libreadline-dev

apt install -y dos2unix nano

	  # Extras that are generally useful
	  yum -y install wget cmake3 octave libxml libxml2-devel bc vim w3m lsof

  # Configure cmake3 as cmake
  alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake3 20 --slave /usr/local/bin/ctest ctest /usr/bin/ctest3 --slave /usr/local/bin/cpack cpack /usr/bin/cpack3 --slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake3 --family cmake

  # Dependencies to build MARTe2 and EPICS
  yum -y install ncurses-devel readline-devel

  # Python and Perl Parse utilities for open62541 (open source impleemntation of OPC UA based on IEC 62541)
  yum -y install python-dateutil python-six perl-ExtUtils-ParseXS
  
  # MDSplus
  yum -y install http://www.mdsplus.org/dist/el7/stable/RPMS/noarch/mdsplus-repo-7.50-0.el7.noarch.rpm
  yum -y install mdsplus-kernel* mdsplus-java* mdsplus-python* mdsplus-devel*
  # Install Development dependencies for SDN (libz !)
  # Is this needed on centos7 ?
  # apt-get install -y zlib1g-dev
}

install_packages_debian11() {
	apt-get update && apt-get install -y build-essential

# Inherited from Dockerfile.rtcc2.model : todo, refactor
#
# TODO: why do we need lapack ?

apt install -y software-properties-common && add-apt-repository --yes ppa:deadsnakes/ppa

apt install -y python3.7 python3.7-dev python3-pip build-essential cmake tar wget libxml2-dev bc libblas3 liblapack3 liblapack-dev libblas-dev gfortran libatlas-base-dev gdb tcl cgdb gdb wireshark vim tmux tcpdump strace shellcheck


apt install -y ncurses-dev libreadline-dev

apt install -y dos2unix nano

apt-get -y install wget octave libxml2 libxml2-dev bc vim git

wget -qO- "https://github.com/Kitware/CMake/releases/download/v3.21.4/cmake-3.21.4-linux-x86_64.tar.gz" | tar --strip-components=1 -xz -C /usr/local
update-alternatives --install /usr/bin/cmake3 cmake /usr/local/bin/cmake 20 --slave /usr/bin/ctest3 ctest /usr/local/bin/ctest --slave /usr/bin/cpack3 cpack /usr/local/bin/cpack --slave /usr/local/bin/ccmake3 ccmake /usr/local/bin/ccmake 

apt-get -y install ncurses-dev libreadline-dev
apt-get -y install python3-dateutil python3-six 
# Install Development dependencies for SDN (libz !)
apt-get install -y zlib1g-dev

	# Development tools

	apt-install vim tmux strace tcpdump wireshark-cli cgdb netcat
}


install_packages(){
	this_distro=$(get_distro)
	case "$this_distro" in
		centos7)
			echo "Installing dependencies for supported distro : $this_distro"
			install_packages_centos7
			;;
		centos)
			echo "Installing dependencies for unsupported distro : $this_distro using centos7"
			install_packages_centos7
			;;
		debian11)
			echo "Installing dependencies for supported distro : $this_distro"
			install_packages_debian11
			;;
		debian|ubuntu18.04)
			echo "Installing dependencies for unsupported distro : $this_distro using debian11"
			install_packages_debian11
			;;
		*)
			echo "Distribution $this_distro is not yet supported."
			exit 54
			;;
	esac
}

if [ "$(whoami)" == "root" ]
then
	install_packages
	exit 0
else
	echo "Run as root user : install packagesuisites if necessary"
	exit 54
fi

