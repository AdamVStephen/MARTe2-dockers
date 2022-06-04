#!/usr/bin/env bash
#
SUPPORTED_DISTROS="centos7 rockylinux ubuntu1804 ubuntu2004 debian11"

builder_completions()
{
  COMPREPLY=($(compgen -W "${SUPPORTED_DISTROS}" "${COMP_WORDS[1]}"))
}
complete -F builder_completions ./docker-build.sh
