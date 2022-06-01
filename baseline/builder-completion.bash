#!/usr/bin/env bash
#
builder_completions()
{
  COMPREPLY=($(compgen -W "centos7 ubuntu1804 ubuntu2004 debian11" "${COMP_WORDS[1]}"))
}
complete -F builder_completions ./builder.sh
