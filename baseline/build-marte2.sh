#!/usr/bin/env bash
#
# Compile MARTe2
#
# Guard against unset variable expansion
set -u
#
SCRIPT="$0"
SCRIPT_DIR=$(dirname $(realpath "$SCRIPT"))
source "${SCRIPT_DIR}/utils.sh"

if [ $# -lt 1 ]
then
	{ echo "Usage: $SCRIPT <target> <target-dir> [opts]"; exit 54; }
fi

TARGET="$1"; shift; 

if [ $# -lt 1 ]
then
	{ echo "Usage: $SCRIPT <target> <target-dir> [opts]"; exit 54; }
fi

INSTALLATION_DIR="$1"; shift
if [ ! -d "$INSTALLATION_DIR" ]
then
	{ echo "$INSTALLATION_DIR doesn't exist"; exit 55; }
fi

REF=develop

case "$TARGET" in
        core)
                if [ $# -eq 1 ]; then REF=$1; shift; fi
                cd "${INSTALLATION_DIR}/MARTe2" && git checkout "$REF" && make -f Makefile.x86-linux
                ;;
        sdn)
                cd "${INSTALLATION_DIR}/SDN_1.0.12_nonCCS" && make
                ;;
        components)
                if [ $# -eq 1 ]; then REF=$1; shift; fi
                cd "${INSTALLATION_DIR}/MARTe2-components" && git checkout "$REF" && make -f Makefile.x86-linux
                ;;
        *)
                echo "Target $TARGET is not supported"
                ;;
esac
